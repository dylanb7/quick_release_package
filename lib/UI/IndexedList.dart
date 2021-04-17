part of '../quick_release_package.dart';

final indexedListKey = GlobalKey();

class IndexedList extends StatefulWidget {
  final LinkedHashMap<IndexScrollWidget, IndexListWidget> contents;

  final ClickController clickController;

  final Duration _scrollDuration;

  final ScrollController scrollController;

  final ValueNotifier<bool> isScrollable;

  IndexedList(this.contents, this.clickController,
      {Duration scrollDuration = const Duration(milliseconds: 500),
      ScrollController scrollController,
      ValueNotifier<bool> isScrollable})
      : this._scrollDuration = scrollDuration,
        this.scrollController = scrollController,
        this.isScrollable = isScrollable ?? ValueNotifier<bool>(true);

  @override
  State<StatefulWidget> createState() {
    return _IndexedListState();
  }
}

class _IndexedListState extends State<IndexedList> {
  ScrollController _scrollController;

  Map<int, IndexListWidget> indexedButtons;

  List<IndexScrollWidget> content;

  final ValueNotifier<bool> autoScrolling = ValueNotifier<bool>(false);

  @override
  void initState() {
    _scrollController = widget.scrollController ?? ScrollController();

    widget.clickController.addScrollListener(autoScrolling);

    indexedButtons = {};
    content = widget.contents.keys.toList(growable: false);
    for (int i = 0; i < content.length; i++) {
      final IndexListWidget button = widget.contents[content[i]];
      if (button != null) {
        indexedButtons[i] = button;
      }
    }

    _scrollController.addListener(() => _handleScroll());

    widget.clickController.addListener(() async {
      if (widget.clickController.goTo && !autoScrolling.value) {
        final int index = indexedButtons.entries
            .singleWhere(
                (element) => element.value == widget.clickController.selected)
            .key;
        autoScrolling.value = true;
        await _scrollToIndex(index);
        autoScrolling.value = false;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isScrollable,
      builder: (context, value, widget) {
        return ListView(
          key: indexedListKey,
          physics: value
              ? AlwaysScrollableScrollPhysics()
              : NeverScrollableScrollPhysics(),
          addAutomaticKeepAlives: true,
          controller: _scrollController,
          children: [...content],
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    widget.clickController.dispose();
    super.dispose();
  }

  bool _handleScroll() {
    if (autoScrolling.value) {
      setState(() {});
      return false;
    }
    final MapEntry<int, IndexListWidget> entry = indexedButtons.entries
        .firstWhere((element) => _indexOnScreen(element.key), orElse: () {
      return null;
    });
    if (entry != null)
      widget.clickController.setSelected(entry.value);
    else
      widget.clickController.setSelected(null);
    setState(() {});
    return false;
  }

  double _getOffset(int index) {
    double off = 0;
    for (int i = 0; i < index; i++) off += content[i].height;
    return off;
  }

  bool _indexOnScreen(int index) {
    final double offset = _getOffset(index);
    final double widgetHeight = content[index].height/2;
    final double relOff = offset - _scrollController.offset;
    return relOff+widgetHeight >= 0 && relOff <= listHeight;
  }

  Future _scrollToIndex(int index) async {
    return await _scrollController.animateTo(_getOffset(index),
        duration: widget._scrollDuration, curve: Curves.easeIn);
  }

  double get listHeight => (indexedListKey.currentContext.findRenderObject() as RenderBox).size.height;

}

class ClickController extends ChangeNotifier {
  IndexListWidget selected;

  bool goTo = false;

  bool autoScroll = false;

  addScrollListener(ValueNotifier<bool> autoScrolling) {
    autoScrolling.addListener(() {
      autoScroll = autoScrolling.value;
    });
  }

  clicked(IndexListWidget button) {
    if (autoScroll) return;
    selected?._highlight(false);
    selected = button;
    selected?._highlight(true);
    goTo = true;
    notifyListeners();
  }

  setSelected(IndexListWidget indexListWidget) {
    if(selected == indexListWidget)
      return;
    goTo = false;
    selected?._highlight(false);
    selected = indexListWidget;
    selected?._highlight(true);
    notifyListeners();
  }
}

mixin IndexScrollWidget on Widget {
  double get height;
}

abstract class IndexListWidget extends StatefulWidget {
  final ClickController controller;

  IndexListWidget(this.controller);

  _highlight(bool highlighted) {
    if (_selectable.containsKey(this))
      _selectable[this].setHighlighted(highlighted);
  }
}

Map<IndexListWidget, IndexListWidgetState> _selectable = {};

abstract class IndexListWidgetState<T extends IndexListWidget>
    extends State<T> {
  bool highlighted = false;

  ClickController controller;

  @override
  void initState() {
    _selectable[widget] = this;
    super.initState();
  }

  @override
  void dispose() {
    if (_selectable.containsKey(widget)) _selectable.remove(widget);
    super.dispose();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.key != widget.key) _selectable[widget] = this;
  }

  pressed() => widget.controller.clicked(widget);

  setHighlighted(bool isHighlighted) {
    setState(() {
      this.highlighted = isHighlighted;
    });
  }
}
