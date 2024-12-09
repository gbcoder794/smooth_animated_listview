import 'package:flutter/material.dart';

class SmoothAnimatedList<T> extends StatefulWidget {
  final List<T> items;
  final bool reverse;
  final ScrollController? controller;
  final bool primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final Clip clipBehavior;
  final Axis scrollDirection;

  final Widget Function(
      BuildContext context, T item, Animation<double> animation) itemBuilder;
  final Duration duration;
  final bool Function(T a, T b)? areItemsTheSame;

  const SmoothAnimatedList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.duration = const Duration(milliseconds: 300),
    this.areItemsTheSame,
    this.controller,
    this.physics,
    this.padding,
    this.clipBehavior = Clip.hardEdge,
    this.primary = true,
    this.reverse = false,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
  });

  @override
  State<SmoothAnimatedList<T>> createState() => _SmoothAnimatedListState<T>();
}

class _SmoothAnimatedListState<T> extends State<SmoothAnimatedList<T>> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<T> _items = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.items);
    _isInitialized = true;
  }

  @override
  void didUpdateWidget(SmoothAnimatedList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isInitialized) return;

    // Compare old and new lists
    final newItems = widget.items;
    final removedItems = _findRemovedItems(_items, newItems);
    final addedItems = _findAddedItems(_items, newItems);

    // Handle removals first
    for (final item in removedItems) {
      final index = _items.indexOf(item);
      if (index != -1) {
        _removeItem(index, item);
      }
    }

    // Handle additions
    for (var i = 0; i < newItems.length; i++) {
      if (addedItems.contains(newItems[i])) {
        _insertItem(i, newItems[i]);
      }
    }

    _items = List.from(newItems);
  }

  List<T> _findRemovedItems(List<T> oldList, List<T> newList) {
    return oldList.where((item) => !_containsItem(newList, item)).toList();
  }

  List<T> _findAddedItems(List<T> oldList, List<T> newList) {
    return newList.where((item) => !_containsItem(oldList, item)).toList();
  }

  bool _containsItem(List<T> list, T item) {
    if (widget.areItemsTheSame != null) {
      return list.any((element) => widget.areItemsTheSame!(element, item));
    }
    return list.contains(item);
  }

  void _removeItem(int index, T item) {
    _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(context, item, animation),
      duration: widget.duration,
    );
  }

  void _insertItem(int index, T item) {
    _items.insert(index, item);
    _listKey.currentState?.insertItem(index, duration: widget.duration);
  }

  Widget _buildItem(BuildContext context, T item, Animation<double> animation) {
    return Material(
      color: Colors.transparent,
      child: widget.itemBuilder(context, item, animation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      shrinkWrap: widget.shrinkWrap,
      reverse: widget.reverse,
      primary: widget.primary,
      physics: widget.physics,
      padding: widget.padding,
      clipBehavior: widget.clipBehavior,
      controller: widget.controller,
      scrollDirection: widget.scrollDirection,
      key: _listKey,
      initialItemCount: _items.length,
      itemBuilder: (context, index, animation) {
        return _buildItem(context, _items[index], animation);
      },
    );
  }
}
