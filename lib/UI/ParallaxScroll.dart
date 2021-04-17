part of '../quick_release_package.dart';

class ParallaxScroll extends StatefulWidget {
  //infinite width
  final SizedBox _top;

  final List<Widget> _under;

  final double _parallaxEffect;

  final double _fadeProportion;

  ParallaxScroll(this._top, this._under,
      {double parallaxEffect = 0.25, double fadeProportion = 0.2})
      : this._parallaxEffect = parallaxEffect,
        this._fadeProportion = fadeProportion;

  @override
  State<StatefulWidget> createState() {
    return _ParallaxScrollState();
  }
}

class _ParallaxScrollState extends State<ParallaxScroll> {
  ScrollController _scrollController;

  double _currOffset = 0.0;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color fade = Theme.of(context).backgroundColor;
    return NotificationListener<ScrollNotification>(
        onNotification: _handleScroll,
        child: Stack(
          children: [
            Positioned(
                top: -widget._parallaxEffect * _currOffset, child: widget._top),
            Positioned(
              top: widget._top.height * (1-widget._fadeProportion) - _currOffset,
              left: 0.0,
              right: 0.0,
              height: widget._top.height * widget._fadeProportion,
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
            ListView(
              cacheExtent: 100.0,
              addAutomaticKeepAlives: false,
              controller: _scrollController,
              children: [...widget._under],
            )
          ],
        ));
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  bool _handleScroll(ScrollNotification scrollNotification) {
    if (_scrollController is ScrollUpdateNotification)
      _currOffset = _scrollController.position.pixels;
    setState(() {});
    return false;
  }
}
