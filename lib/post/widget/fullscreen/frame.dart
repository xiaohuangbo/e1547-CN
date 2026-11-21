import 'package:e1547/post/post.dart';
import 'package:e1547/shared/shared.dart';
import 'package:e1547/task/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sub/flutter_sub.dart';

class PostFullscreenFrame extends StatelessWidget {
  const PostFullscreenFrame({
    super.key,
    required this.child,
    required this.post,
    this.drawer,
    this.endDrawer,
    this.floatingActionButton,
  });

  final Post post;
  final Widget child;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        appBarTheme: theme.appBarTheme.copyWith(
          systemOverlayStyle: theme.appBarTheme.systemOverlayStyle!.copyWith(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.black26,
          ),
        ),
      ),
      child: ScaffoldFrame(
        controller: ScaffoldFrame.maybeOf(context),
        child: _SuppressBubbleWhileFrameHidden(
          child: ScaffoldFrameSystemUI(
            child: Builder(
              builder: (context) {
                VideoPlayer? player = post.getVideo(context);
                return AdaptiveScaffold(
                  backgroundColor: Colors.transparent,
                  extendBodyBehindAppBar: true,
                  extendBody: true,
                  appBar: ScaffoldFrameAppBar(
                    child: PostFullscreenAppBar(post: post),
                  ),
                  drawer: drawer,
                  endDrawer: endDrawer,
                  bottomNavigationBar: player != null
                      ? DismissFade(child: VideoBar(player: player))
                      : null,
                  body: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      ScaffoldFrameController controller = ScaffoldFrame.of(
                        context,
                      );
                      controller.toggleFrame();
                      if ((player?.state.playing ?? false) &&
                          controller.visible) {
                        controller.hideFrame(
                          duration: const Duration(seconds: 2),
                        );
                      }
                    },
                    child: Stack(
                      fit: StackFit.passthrough,
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: DismissFade(
                            child: ColoredBox(
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                        if (player != null)
                          DragToDismiss(
                            child: Stack(
                              fit: StackFit.passthrough,
                              alignment: Alignment.center,
                              children: [
                                child,
                                DismissFade(child: VideoButton(player: player)),
                              ],
                            ),
                          )
                        else
                          child,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SuppressBubbleWhileFrameHidden extends StatefulWidget {
  const _SuppressBubbleWhileFrameHidden({required this.child});

  final Widget child;

  @override
  State<_SuppressBubbleWhileFrameHidden> createState() =>
      _SuppressBubbleWhileFrameHiddenState();
}

class _SuppressBubbleWhileFrameHiddenState
    extends State<_SuppressBubbleWhileFrameHidden> {
  TasksController? _tasks;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tasks = context.read<TasksController?>();
  }

  @override
  void dispose() {
    final TasksController? tasks = _tasks;
    if (tasks != null && tasks.suppressBubble.value) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => tasks.suppressBubble.value = false,
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScaffoldFrameController frame = ScaffoldFrame.of(context);
    return SubListener(
      listenable: frame,
      listener: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _tasks?.suppressBubble.value = !frame.visible;
        });
      },
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _tasks?.suppressBubble.value = !frame.visible;
        });
        return widget.child;
      },
    );
  }
}
