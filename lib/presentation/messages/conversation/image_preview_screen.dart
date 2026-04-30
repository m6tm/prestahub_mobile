import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PreviewImageItem {
  final String heroTag;
  final String imageUrl;
  final String senderLabel;
  final String time;

  const PreviewImageItem({
    required this.heroTag,
    required this.imageUrl,
    required this.senderLabel,
    required this.time,
  });
}

class ImagePreviewScreen extends StatefulWidget {
  final List<PreviewImageItem> items;
  final int initialIndex;

  const ImagePreviewScreen({
    super.key,
    required this.items,
    required this.initialIndex,
  });

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen>
    with TickerProviderStateMixin {
  late final PageController _pageCtrl;
  late int _currentIndex;
  bool _chromeVisible = true;

  final Map<int, TransformationController> _transformControllers = {};
  final Map<int, AnimationController> _zoomControllers = {};
  final Map<int, Animation<Matrix4>> _zoomAnims = {};
  TapDownDetails? _lastTapDown;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageCtrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    for (final c in _transformControllers.values) {
      c.dispose();
    }
    for (final c in _zoomControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TransformationController _transformCtrlFor(int index) {
    return _transformControllers.putIfAbsent(
      index,
      () => TransformationController(),
    );
  }

  AnimationController _zoomCtrlFor(int index) {
    return _zoomControllers.putIfAbsent(index, () {
      final c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 220),
      )..addListener(() {
          final anim = _zoomAnims[index];
          if (anim != null) {
            _transformCtrlFor(index).value = anim.value;
          }
        });
      return c;
    });
  }

  void _handleDoubleTap(int index, Size viewport) {
    final ctrl = _transformCtrlFor(index);
    final isZoomed = ctrl.value != Matrix4.identity();
    final end = isZoomed ? Matrix4.identity() : _zoomedMatrix();
    _zoomAnims[index] = Matrix4Tween(begin: ctrl.value, end: end).animate(
      CurvedAnimation(parent: _zoomCtrlFor(index), curve: Curves.easeOutCubic),
    );
    _zoomCtrlFor(index).forward(from: 0);
  }

  Matrix4 _zoomedMatrix() {
    final position = _lastTapDown?.localPosition;
    if (position == null) {
      return Matrix4.identity()..scaleByDouble(2.5, 2.5, 1, 1);
    }
    final x = -position.dx * 1.5;
    final y = -position.dy * 1.5;
    return Matrix4.identity()
      ..translateByDouble(x, y, 0, 1)
      ..scaleByDouble(2.5, 2.5, 1, 1);
  }

  void _resetZoom(int index) {
    final ctrl = _transformCtrlFor(index);
    if (ctrl.value != Matrix4.identity()) {
      ctrl.value = Matrix4.identity();
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.items[_currentIndex];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageCtrl,
              itemCount: widget.items.length,
              onPageChanged: (i) {
                _resetZoom(_currentIndex);
                setState(() => _currentIndex = i);
              },
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final viewport =
                        Size(constraints.maxWidth, constraints.maxHeight);
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () =>
                          setState(() => _chromeVisible = !_chromeVisible),
                      onDoubleTapDown: (d) => _lastTapDown = d,
                      onDoubleTap: () => _handleDoubleTap(index, viewport),
                      child: Center(
                        child: Hero(
                          tag: item.heroTag,
                          child: InteractiveViewer(
                            transformationController: _transformCtrlFor(index),
                            minScale: 1,
                            maxScale: 5,
                            clipBehavior: Clip.none,
                            child: Image.network(
                              item.imageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white70,
                                  ),
                                );
                              },
                              errorBuilder: (_, _, _) => const Center(
                                child: Icon(
                                  Icons.broken_image_rounded,
                                  size: 48,
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _chromeVisible ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: IgnorePointer(
                  ignoring: !_chromeVisible,
                  child: _buildTopBar(current),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedOpacity(
                opacity: _chromeVisible ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: IgnorePointer(
                  ignoring: !_chromeVisible,
                  child: _buildBottomBar(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(PreviewImageItem current) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC000000), Color(0x00000000)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 12, 16),
          child: Row(
            children: [
              _iconButton(
                icon: Icons.close_rounded,
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      current.senderLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.items.length > 1
                          ? '${_currentIndex + 1}/${widget.items.length} · ${current.time}'
                          : current.time,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
              _iconButton(icon: Icons.more_vert_rounded, onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color(0xCC000000), Color(0x00000000)],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _bottomAction(icon: Icons.reply_rounded, label: 'Répondre'),
              _bottomAction(icon: Icons.forward_rounded, label: 'Transférer'),
              _bottomAction(icon: Icons.download_rounded, label: 'Enregistrer'),
              _bottomAction(icon: Icons.ios_share_rounded, label: 'Partager'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Icon(icon, size: 22, color: Colors.white),
      ),
    );
  }

  Widget _bottomAction({required IconData icon, required String label}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
