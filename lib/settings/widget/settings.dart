import 'dart:async';
import 'dart:io';

import 'package:e1547/app/app.dart';
import 'package:e1547/client/client.dart';
import 'package:e1547/follow/follow.dart';
import 'package:e1547/identity/identity.dart';
import 'package:e1547/logs/logs.dart';
import 'package:e1547/settings/settings.dart';
import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';
import 'package:local_auth/local_auth.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, child) => Scaffold(
        appBar: const DefaultAppBar(title: Text('设置')),
        body: LimitedWidthLayout.builder(
          builder: (context) => ListView(
            primary: true,
            padding: defaultActionListPadding.add(
              LimitedWidthLayout.of(context).padding,
            ),
            children: [
              const SectionHeader(
                indent: SectionHeader.listTileIndent,
                title: '账号',
              ),
              Consumer<IdentityClient>(
                builder: (context, client, child) => IdentityTile(
                  identity: client.identity,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IdentitiesPage(),
                    ),
                  ),
                  trailing: const Icon(Icons.swap_horiz),
                ),
              ),
              const Divider(),
              const SectionHeader(
                indent: SectionHeader.listTileIndent,
                title: '用户',
              ),
              Consumer<Client>(
                builder: (context, client, child) => ValueListenableBuilder(
                  valueListenable: client.traits,
                  builder: (context, traits, child) => ListTile(
                    title: const Text('黑名单'),
                    leading: const Icon(Icons.block),
                    subtitle: traits.denylist.isNotEmpty
                        ? Text(
                            '${traits.denylist.join(' ').split(' ').trim().where((e) => e[0] != '-').length} tags blocked',
                          )
                        : null,
                    onTap: () => Navigator.pushNamed(context, '/blacklist'),
                  ),
                ),
              ),
              Consumer<Client>(
                builder: (context, client, child) => SubStream<int>(
                  create: () => client.follows.count().streamed,
                  keys: [client],
                  builder: (context, snapshot) => ListTile(
                    title: const Text('关注'),
                    subtitle: snapshot.data != null && snapshot.data != 0
                        ? Text('已关注 ${snapshot.data} 个搜索')
                        : null,
                    leading: const Icon(Icons.person_add),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FollowEditor(),
                      ),
                    ),
                  ),
                ),
              ),
              Consumer<Client>(
                builder: (context, client, child) => SubStream<int>(
                  create: () => client.histories.count().streamed,
                  keys: [client],
                  builder: (context, countSnapshot) {
                    int? count = countSnapshot.data;
                    return ValueListenableBuilder(
                      valueListenable: client.traits,
                      builder: (context, traits, child) {
                        bool enabled = traits.writeHistory ?? true;
                        return DividerListTile(
                          title: const Text('历史'),
                          subtitle: enabled && count != null
                              ? Text('已访问 $count 个页面')
                              : null,
                          leading: const Icon(Icons.history),
                          onTap: () => Navigator.pushNamed(context, '/history'),
                          onTapSeparated: () => client.traits.value = client
                              .traits
                              .value
                              .copyWith(writeHistory: !enabled),
                          separated: Switch(
                            value: enabled,
                            onChanged: (value) => client.traits.value = client
                                .traits
                                .value
                                .copyWith(writeHistory: value),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const Divider(),
              const SectionHeader(
                indent: SectionHeader.listTileIndent,
                title: '外观',
              ),
              ValueListenableBuilder<AppTheme>(
                valueListenable: settings.theme,
                builder: (context, value, child) => ListTile(
                  title: const Text('主题'),
                  subtitle: Text(value.name),
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
                                    title: Text(theme.name),
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
                  subtitle: Text(value ? '在帖子格子上显示信息' : '仅显示图片格子'),
                  secondary: const Icon(Icons.subtitles),
                  value: value,
                  onChanged: (value) => settings.showPostInfo.value = value,
                ),
              ),
              ValueListenableBuilder<Handedness>(
                valueListenable: settings.handedness,
                builder: (context, value, child) => HandednessSettingsTile(
                  state: value,
                  onChange: (value) => settings.handedness.value = value,
                ),
              ),
              const Divider(),
              const SectionHeader(
                indent: SectionHeader.listTileIndent,
                title: '互动',
              ),
              if (!Platform.isIOS)
                ValueListenableBuilder<String?>(
                  valueListenable: settings.downloadPath,
                  builder: (context, value, child) => ListTile(
                    title: const Text('下载位置'),
                    subtitle: value != null
                        ? Text(FileDownloader.displayPath(value))
                        : null,
                    leading: const Icon(Icons.folder),
                    onTap: () async {
                      String? result = await FileDownloader.pickDirectory(
                        initial: value,
                      );
                      if (result != null) {
                        unawaited(FileDownloader.forgetDirectory(value));
                        settings.downloadPath.value = result;
                      }
                    },
                  ),
                ),
              ValueListenableBuilder<bool>(
                valueListenable: settings.upvoteFavs,
                builder: (context, value, child) => SwitchListTile(
                  title: const Text('点赞收藏'),
                  subtitle: Text(value ? '点赞并收藏' : 'favorite only'),
                  secondary: const Icon(Icons.arrow_upward),
                  value: value,
                  onChanged: (value) => settings.upvoteFavs.value = value,
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: settings.swipeToClose,
                builder: (context, value, child) => SwitchListTile(
                  title: const Text('滑动关闭'),
                  subtitle: Text(value ? '下滑以关闭' : '按钮和返回手势'),
                  secondary: const Icon(Icons.swipe_down),
                  value: value,
                  onChanged: (value) => settings.swipeToClose.value = value,
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: settings.muteVideos,
                builder: (context, value, child) => SwitchListTile(
                  title: const Text('视频音量'),
                  subtitle: Text(value ? '已静音' : '有声'),
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
              const SectionHeader(
                indent: SectionHeader.listTileIndent,
                title: '安全',
              ),
              if (PlatformCapabilities.hasSecureDisplay)
                ValueListenableBuilder<bool>(
                  valueListenable: settings.secureDisplay,
                  builder: (context, value, child) => SwitchListTile(
                    title: const Text('安全显示'),
                    subtitle: Text(
                      value ? 'screen protected' : 'screen visible',
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
                    value != null ? 'PIN enabled' : 'PIN disabled',
                  ),
                  secondary: const Icon(Icons.pin),
                  value: value != null,
                  onChanged: (value) async {
                    if (value) {
                      String? pin = await choosePin(context);
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
                      value ? 'biometrics enabled' : 'biometrics disabled',
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
              const SectionHeader(
                indent: SectionHeader.listTileIndent,
                title: '开发',
              ),
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
                Consumer<LogErrors>(
                  builder: (context, errors, child) => ListTile(
                    leading: const Icon(Icons.format_list_numbered),
                    title: const Text('日志'),
                    subtitle: errors.isEmpty
                        ? null
                        : Text('已记录 ${errors.length} 个错误'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LogsPage()),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('数据库'),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DatabaseManagementPage(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
