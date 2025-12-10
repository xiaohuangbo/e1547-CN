import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:e1547/app/app.dart';
import 'package:e1547/app/data/link.dart' as link;
import 'package:e1547/client/client.dart';
import 'package:e1547/history/history.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<String> prepareGithubIssue() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String body = '';

  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    body += '### Device Info\n';
    body += 'OS: Android ${androidInfo.version.release}\n';
    body += 'SDK: ${androidInfo.version.sdkInt}\n';
    body += 'Model: ${androidInfo.model}\n';
    body += 'Brand: ${androidInfo.brand}\n';
    body += 'Device: ${androidInfo.device}\n';
    body += 'Product: ${androidInfo.product}\n';
    body += 'Hardware: ${androidInfo.hardware}\n';
    body += '\n';
  } else if (Platform.isIOS) {
    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    body += '### Device Info\n';
    body += 'OS: ${iosInfo.systemName} ${iosInfo.systemVersion}\n';
    body += 'Model: ${iosInfo.model}\n';
    body += 'Name: ${iosInfo.name}\n';
    body += '\n';
  }

  body += '### App Info\n';
  body += 'Version: ${packageInfo.version}\n';
  body += 'Build number: ${packageInfo.buildNumber}\n';

  return 'https://github.com/xiaohuangbo/e1547-CN/issues/new?body=${Uri.encodeComponent(body)}';
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Client>(
      builder: (context, client, child) => Scaffold(
        appBar: const DefaultAppBar(title: Text('设置')),
        drawer: const RouterDrawer(),
        body: Consumer<Settings>(
          builder: (context, settings, child) => ListView(
            children: [
              const ListTileHeader(title: '常规'),
              ValueListenableBuilder<bool>(
                valueListenable: settings.autoRotate,
                builder: (context, value, child) => SwitchListTile(
                  title: const Text('自动旋转'),
                  subtitle: Text(value ? '已启用' : '已禁用'),
                  secondary: const Icon(Icons.screen_rotation),
                  value: value,
                  onChanged: (value) => settings.autoRotate.value = value,
                ),
              ),
              ListTile(
                title: const Text('清除缓存'),
                subtitle: const Text('清除所有缓存的图片和网络响应'),
                leading: const Icon(Icons.delete_forever),
                onTap: () async {
                  bool? result = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('确认？'),
                      content: const Text(
                        '这将从您的设备中删除所有缓存的数据。\n它不会影响您的设置或已保存的媒体。'
                      ),
                      actions: [
                        TextButton(
                          child: const Text('取消'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text('确认'),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    ),
                  );
                  if (result ?? false) {
                    await client.clearCache();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('缓存已清除'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  }
                },
              ),
              if (client.histories case final HistoryService clientHistories) ...[
                const Divider(),
                SubStream<bool>(
                  create: () => clientHistories.enabledStream,
                  builder: (context, snapshot) {
                    return SubFuture<bool>(
                      create: () async => clientHistories.enabled,
                      builder: (context, snapshot) {
                        bool enabled = snapshot.data ?? true;
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: const Text('历史记录'),
                          subtitle: Text(enabled ? '已启用' : '已禁用'),
                          trailing: enabled
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      child: const Text('清除'),
                                      onPressed: () async => clientHistories.clear(),
                                    ),
                                    Switch(
                                      value: enabled,
                                      onChanged: (value) =>
                                          clientHistories.enabled = value,
                                    ),
                                  ],
                                )
                              : Switch(
                                  value: enabled,
                                  onChanged: (value) =>
                                      clientHistories.enabled = value,
                                ),
                          onTap: () =>
                              clientHistories.enabled = !enabled,
                        );
                      },
                    );
                  },
                ),
              ],
              const Divider(),
              const ListTileHeader(title: '外观'),
              ValueListenableBuilder<AppTheme>(
                valueListenable: settings.theme,
                builder: (context, value, child) => ListTile(
                  title: const Text('主题'),
                  subtitle: Text(value.title),
                  leading: const Icon(Icons.brightness_6),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        title: const Text('主题'),
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: AppTheme.values
                                .map(
                                  (theme) => ListTile(
                                    title: Text(theme.title),
                                    trailing: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.data.cardColor,
                                        border: Border.all(
                                          color: Theme.of(
                                            context,
                                          ).iconTheme.color!,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      settings.theme.value = theme;
                                      Navigator.of(context).maybePop();
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: settings.tileSize,
                    builder: (context, value, child) => ListTile(
                      title: const Text('格子尺寸'),
                      subtitle: Text(value.toString()),
                      leading: const Icon(Icons.crop),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => RangeDialog(
                          title: const Text('格子尺寸'),
                          value: NumberRange(value),
                          initialMode: RangeDialogMode.exact,
                          enforceMax: false,
                          canChangeMode: false,
                          division: (300 / 50).round(),
                          min: 100,
                          max: 400,
                          onSubmit: (value) {
                            if (value == null || value.value <= 0) {
                              return;
                            }
                            settings.tileSize.value = value.value;
                          },
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<GridQuilt>(
                    valueListenable: settings.quilt,
                    builder: (context, value, child) => GridSettingsTile(
                      state: value,
                      onChange: (value) => settings.quilt.value = value,
                    ),
                  ),
                ],
              ),
              ValueListenableBuilder<bool>(
                valueListenable: settings.showPostInfo,
                builder: (context, value, child) => SwitchListTile(
                  title: const Text('帖子信息'),
                  subtitle: Text(
                    value ? '在帖子格子上显示信息' : '仅显示图片格子',
                  ),
                  secondary: const Icon(Icons.subtitles),
                  value: value,
                  onChanged: (value) => settings.showPostInfo.value = value,
                ),
              ),
              const Divider(),
              const ListTileHeader(title: '互动'),
              ValueListenableBuilder<bool>(
                valueListenable: settings.upvoteFavs,
                builder: (context, value, child) => SwitchListTile(
                  title: const Text('点赞收藏'),
                  subtitle: Text(value ? '同时收藏' : '仅收藏'),
                  secondary: const Icon(Icons.arrow_upward),
                  value: value,
                  onChanged: (value) => settings.upvoteFavs.value = value,
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: settings.muteVideos,
                builder: (context, value, child) => SwitchListTile(
                  title: const Text('视频音量'),
                  subtitle: Text(value ? '静音' : '有声'),
                  secondary: Icon(value ? Icons.volume_off : Icons.volume_up),
                  value: value,
                  onChanged: (value) => settings.muteVideos.value = value,
                ),
              ),
              ValueListenableBuilder<VideoResolution>(
                valueListenable: settings.videoResolution,
                builder: (context, value, child) => ListTile(
                  title: const Text('视频分辨率'),
                  subtitle: Text(value.title),
                  leading: const Icon(Icons.video_settings),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: const Text('视频分辨率'),
                      children: VideoResolution.values
                          .map(
                            (resolution) => ListTile(
                              title: Text(resolution.title),
                              onTap: () {
                                settings.videoResolution.value = resolution;
                                Navigator.of(context).maybePop();
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              const Divider(),
              const ListTileHeader(title: '安全'),
              if (PlatformCapabilities.hasSecureDisplay)
                ValueListenableBuilder<bool>(
                  valueListenable: settings.secureDisplay,
                  builder: (context, value, child) => SwitchListTile(
                    title: const Text('安全显示'),
                    subtitle: Text(
                      value ? '屏幕已保护' : '屏幕可见',
                    ),
                    secondary: const Icon(Icons.stop_screen_share_outlined),
                    value: value,
                    onChanged: (value) => settings.secureDisplay.value = value,
                  ),
                ),
              if (Platform.isAndroid)
                ValueListenableBuilder<bool>(
                  valueListenable: settings.incognitoKeyboard,
                  builder: (context, value, child) => SwitchListTile(
                    title: const Text('无痕键盘'),
                    subtitle: Text(value ? '已启用' : '已禁用'),
                    secondary: const Icon(Icons.keyboard),
                    value: value,
                    onChanged: (value) =>
                        settings.incognitoKeyboard.value = value,
                  ),
                ),
              ValueListenableBuilder<String?>(
                valueListenable: settings.appPin,
                builder: (context, value, child) => SwitchListTile(
                  title: const Text('PIN 锁'),
                  subtitle: Text(
                    value != null ? 'PIN 已启用' : 'PIN 已禁用',
                  ),
                  secondary: const Icon(Icons.pin),
                  value: value != null,
                  onChanged: (value) async {
                    if (value) {
                      String? pin = await registerPin(context);
                      if (pin != null) {
                        settings.appPin.value = pin;
                      }
                    } else {
                      settings.appPin.value = null;
                    }
                  },
                ),
              ),
              SubFuture<bool>(
                create: () => LocalAuthentication()
                    .getAvailableBiometrics()
                    .then((e) => e.isNotEmpty),
                builder: (context, snapshot) => ValueListenableBuilder<bool>(
                  valueListenable: settings.biometricAuth,
                  builder: (context, value, child) => SwitchListTile(
                    title: const Text('生物识别锁'),
                    subtitle: Text(
                      value ? '生物识别已启用' : '生物识别已禁用',
                    ),
                    secondary: const Icon(Icons.fingerprint),
                    value: value,
                    onChanged: (snapshot.data ?? false)
                        ? (value) => settings.biometricAuth.value = value
                        : null,
                  ),
                ),
              ),
              const Divider(),
              const ListTileHeader(title: '开发'),
              ValueListenableBuilder<bool>(
                valueListenable: settings.showDev,
                builder: (context, value, child) {
                  if (!value) return const SizedBox();
                  return SwitchListTile(
                    title: const Text('开发者模式'),
                    subtitle: Text(value ? '选项已显示' : '选项已隐藏'),
                    secondary: const Icon(Icons.bug_report),
                    value: value,
                    onChanged: (value) => settings.showDev.value = value,
                  );
                },
              ),
              if (context.watch<Logs?>() != null) ...[
                Consumer<Logs>(
                  builder: (context, logs, child) => SubStream<List<LogRecord>>(
                    create: () => logs.stream(
                      filter: (level, type) => level >= Level.SEVERE,
                    ),
                    builder: (context, snapshot) => ListTile(
                      leading: const Icon(Icons.format_list_numbered),
                      title: const Text('日志'),
                      subtitle: (snapshot.data?.isNotEmpty ?? false)
                          ? Text('${snapshot.data!.length} 条目')
                          : null,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LogsPage(),
                        ),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.bug_report),
                  title: const Text('报告错误'),
                  subtitle: const Text(
                      '在 Github 上打开一个问题以便我们可以修复它。\n如果您遇到特定帖子的错误，请在该帖子上执行此操作。'
                  ),
                  onTap: () async => link.launch(await prepareGithubIssue()),
                ),
              ],
              const Divider(),
              ListTile(
                title: const Text('关于'),
                leading: const Icon(Icons.info),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AboutDialog(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
