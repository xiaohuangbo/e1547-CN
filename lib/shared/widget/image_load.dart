import 'dart:async';
import 'dart:math';

import 'package:e1547/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const Duration imageLoadPatience = Duration(milliseconds: 250);
const double imageLoadBar = 3;

Rect? containedRect(Size content, Size size) {
  if (content.isEmpty) return null;
  return FittedContent(
    fit: BoxFit.contain,
    aspectRatio: content.aspectRatio,
  ).locate(size);
}

@immutable
sealed class ImageLoad {
  const ImageLoad();
}

class ImageLoading extends ImageLoad {
  const ImageLoading([this.fraction]);

  final double? fraction;

  @override
  bool operator ==(Object other) =>
      other is ImageLoading && other.fraction == fraction;

  @override
  int get hashCode => fraction.hashCode;
}

class ImageLoaded extends ImageLoad {
  const ImageLoaded();

  @override
  bool operator ==(Object other) => other is ImageLoaded;

  @override
  int get hashCode => 0;
}

class ImageFailed extends ImageLoad {
  const ImageFailed(this.error);

  final Object error;

  @override
  bool operator ==(Object other) =>
      other is ImageFailed && other.error == error;

  @override
  int get hashCode => error.hashCode;
}

class ImageLoadController extends ValueNotifier<ImageLoad> {
  ImageLoadController() : super(const ImageLoading());

  final Set<String> _settled = {};
  bool _disposed = false;

  void report(String url, ImageLoad next) {
    if (next is ImageLoading && _settled.contains(url)) return;
    if (next is! ImageLoading) _settled.add(url);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_disposed || next == value) return;
      if (next is ImageLoading && _settled.contains(url)) return;
      value = next;
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class ImageLoadOverlay extends StatefulWidget {
  const ImageLoadOverlay({
    super.key,
    required this.load,
    required this.locate,
    this.moves,
  });

  final ImageLoadController load;
  final Rect? Function(Size size) locate;
  final Listenable? moves;

  @override
  State<ImageLoadOverlay> createState() => _ImageLoadOverlayState();
}

class _ImageLoadOverlayState extends State<ImageLoadOverlay> {
  Timer? _patience;
  bool _patient = false;

  @override
  void initState() {
    super.initState();
    widget.load.addListener(_onLoad);
    _onLoad();
  }

  @override
  void didUpdateWidget(ImageLoadOverlay old) {
    super.didUpdateWidget(old);
    if (old.load == widget.load) return;
    old.load.removeListener(_onLoad);
    widget.load.addListener(_onLoad);
    _onLoad();
  }

  @override
  void dispose() {
    widget.load.removeListener(_onLoad);
    _patience?.cancel();
    super.dispose();
  }

  void _onLoad() {
    switch (widget.load.value) {
      case ImageLoading():
        if (_patient || (_patience?.isActive ?? false)) return;
        _patience = Timer(imageLoadPatience, () {
          if (mounted) setState(() => _patient = true);
        });
      case ImageLoaded():
      case ImageFailed():
        _patience?.cancel();
        _patient = false;
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) => ListenableBuilder(
      listenable: Listenable.merge([widget.load, ?widget.moves]),
      builder: (context, _) {
        final Size size = box.biggest;
        final Rect? image = widget.locate(size);
        if (image == null) return const SizedBox.shrink();
        final Rect visible = image.intersect(Offset.zero & size);
        if (visible.width <= 0 || visible.height <= 0) {
          return const SizedBox.shrink();
        }
        final double top = max(image.top, 0);
        return Stack(
          children: [
            switch (widget.load.value) {
              ImageLoading(:final double? fraction) when _patient => Positioned(
                left: visible.left,
                width: visible.width,
                top: top,
                height: imageLoadBar,
                child: IgnorePointer(
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: imageLoadBar,
                    backgroundColor: Colors.white24,
                  ),
                ),
              ),
              _ => const SizedBox.shrink(),
            },
          ],
        );
      },
    ),
  );
}
