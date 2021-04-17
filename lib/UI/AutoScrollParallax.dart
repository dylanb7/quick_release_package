part of '../quick_release_package.dart';

class AutoScrollParallax<T> extends StatefulWidget {
  final SizedBox _top;

  final double _parallaxEffect;

  final LinkedHashMap<IndexScrollWidget, IndexListWidget> contents;

  final ClickController clickController;

  final Duration _scrollDuration;

  final double _fadeProportion;

  final Color _fadeColor;

  AutoScrollParallax(
    this._top,
    this.contents,
    this.clickController, {
    double parallaxEffect = 2,
    double fadeProportion = 0.2,
    Duration scrollDuration = const Duration(milliseconds: 500),
    Color fadeColor,
  })  : this._parallaxEffect = parallaxEffect,
        this._scrollDuration = scrollDuration,
        this._fadeProportion = fadeProportion,
        this._fadeColor = fadeColor;

  @override
  State<StatefulWidget> createState() {
    return _AutoParallaxScrollState();
  }
}

class _AutoParallaxScrollState extends State<AutoScrollParallax>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;

  AnimationController _animationController;

  Animation _topAnimation, _parallaxAnimation;

  Map<int, IndexListWidget> indexedButtons;

  List<Widget> content;

  ValueNotifier<bool> scrollable = ValueNotifier<bool>(false);

  double parallaxTop = 0.0;

  double top = 0.0;

  @override
  void initState() {
    _scrollController = ScrollController();
    _animationController =
        AnimationController(vsync: this, duration: widget._scrollDuration);
    widget.clickController.addListener(() async {
      if (widget.clickController.goTo) {
        scrollable.value = true;
        if (top > -widget._top.height) {
          setState(() {
            _topAnimation = Tween<double>(begin: top, end: -topHeight)
                .animate(_animationController)
                  ..addListener(() {
                    setState(() {
                      top = _topAnimation.value;
                    });
                  });
            _parallaxAnimation = Tween<double>(
                    begin: parallaxTop,
                    end: -(topHeight / widget._parallaxEffect))
                .animate(_animationController)
                  ..addListener(() {
                    setState(() {
                      parallaxTop = _parallaxAnimation.value;
                    });
                  });
            _animationController.forward(from: 0.0);
          });
        }
      }
    });
    scrollable.addListener(() {
      if (!scrollable.value) widget.clickController.setSelected(null);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color fade = widget._fadeColor ?? Theme.of(context).primaryColor;
    return Listener(
        onPointerSignal: (PointerSignalEvent signal) {
          if (signal is PointerScrollEvent &&
              (isUnderParallaxControl ||
                  _scrollController.offset == 0 && signal.scrollDelta.dy < 0))
            _handleScroll(-signal.scrollDelta.dy);
        },
        child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: (details) {
              if (isUnderParallaxControl) _handleScroll(details.delta.dy);
            },
            child: Stack(
              children: [
                Positioned(child: widget._top, top: parallaxTop),
                Positioned(
                  top: (topHeight * (1 - widget._fadeProportion)) + top,
                  left: 0.0,
                  right: 0.0,
                  height: topHeight * widget._fadeProportion,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const <double>[0, 1],
                        colors: [fade.withAlpha(0), fade],
                      ),
                    ),
                    child: SizedBox(width: double.infinity),
                  ),
                ),
                NotificationListener<ScrollUpdateNotification>(
                    onNotification: (notification) {
                      if (_scrollController.offset == 0.0 &&
                          scrollable.value &&
                          !widget.clickController.autoScroll &&
                          (notification.dragDetails == null ||
                              notification.dragDetails.delta.dy < 0))
                        _scrollBackIn();
                      return false;
                    },
                    child: Positioned(
                        top: top + widget._top.height,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: IndexedList(
                          widget.contents,
                          widget.clickController,
                          scrollDuration: widget._scrollDuration,
                          scrollController: _scrollController,
                          isScrollable: scrollable,
                        ))),
              ],
            )));
  }

  double get topHeight => widget._top.height;

  bool get isUnderParallaxControl =>
      !_animationController.isAnimating &&
      !scrollable.value &&
      _scrollController.offset == 0;

  _scrollBackIn() {
    setState(() {
      parallaxTop = -(topHeight / widget._parallaxEffect) +
          (1.0 / widget._parallaxEffect);
      top = -topHeight + 1;
      scrollable.value = false;
    });
  }

  _handleScroll(double dOff) {
    parallaxTop =
        min(0, max(parallaxTop + (dOff / widget._parallaxEffect), -topHeight));
    top = min(0, max(top + dOff, -topHeight));
    scrollable.value = top <= -topHeight;
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _animationController.dispose();
    widget.clickController.dispose();
    super.dispose();
  }
}
