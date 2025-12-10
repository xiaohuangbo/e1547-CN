import 'dart:math';

import 'package:e1547/client/client.dart';
import 'package:e1547/flag/flag.dart';
import 'package:e1547/interface/interface.dart';
import 'package:e1547/markup/markup.dart';
import 'package:e1547/post/post.dart';
import 'package:e1547/tag/tag.dart';
import 'package:e1547/ticket/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PostFlagScreen extends StatefulWidget {
  const PostFlagScreen({super.key, required this.post});

  final Post post;

  @override
  State<PostFlagScreen> createState() => _PostFlagScreenState();
}

class _PostFlagScreenState extends State<PostFlagScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController parentController = TextEditingController();
  FlagType? type;

  bool isLoading = false;

  @override
  void dispose() {
    scrollController.dispose();
    parentController.dispose();
    super.dispose();
  }

  Future<void> _sendFlag(BuildContext context) async {
    if (Form.of(context).validate()) {
      setState(() {
        isLoading = true;
      });
      scrollController.animateTo(
        0,
        duration: defaultAnimationDuration,
        curve: Curves.easeInOut,
      );
      ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      try {
        await context.read<Client>().flags.create(
          widget.post.id,
          type!.title,
          parent: int.tryParse(parentController.text),
        );
        if (context.mounted) {
          Navigator.of(context).maybePop();
        }
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text('已标记帖子 #${widget.post.id}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } on ClientException {
        messenger.showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text('标记帖子 #${widget.post.id} 失败'),
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Form(
        child: Scaffold(
          appBar: DefaultAppBar(
            elevation: 0,
            title: Text('帖子 #${widget.post.id}'),
            leading: const CloseButton(),
          ),
          floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(
              onPressed: isLoading ? null : () => _sendFlag(context),
              child: const Icon(Icons.check),
            ),
          ),
          body: LimitedWidthLayout(
            child: LayoutBuilder(
              builder: (context, constraints) => ListView(
                controller: scrollController,
                padding: LimitedWidthLayout.of(
                  context,
                ).padding.add(defaultFormScreenPadding),
                children: [
                  PostReportImage(
                    post: widget.post,
                    height: constraints.maxHeight,
                    isLoading: isLoading,
                  ),
                  ReportFormHeader(
                    title: const Text('标记'),
                    icon: IconButton(
                      onPressed: () => showTagSearchPrompt(
                        context: context,
                        tag: 'e621:flag_for_deletion',
                      ),
                      icon: const Icon(Icons.info_outline),
                    ),
                  ),
                  ReportFormDropdown<FlagType?>(
                    type: type,
                    types: {for (final e in FlagType.values) e: e.title},
                    onChanged: (value) => setState(() => type = value),
                    isLoading: isLoading,
                  ),
                  CrossFade.builder(
                    showChild: type == FlagType.inferior,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: TextFormField(
                        enabled: !isLoading,
                        controller: parentController,
                        decoration: const InputDecoration(
                          labelText: '父级 ID',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^ ?\d*')),
                        ],
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return '父级 ID 不能为空';
                          }
                          if (int.tryParse(value) == null) {
                            return '父级 ID 必须是数字';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  CrossFade.builder(
                    showChild: type != null,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 6,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: DText(type!.body),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
