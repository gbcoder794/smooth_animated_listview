# smooth_animated_list

A Flutter package that provides an easy-to-use animated list with smooth transitions for item changes.

## Features

- Automatic animation of item additions and removals
- Smooth fade and size transitions
- Support for custom equality checks
- Type-safe implementation
- Simple API

## Getting started

Add to your pubspec.yaml:

```yaml
dependencies:
  smooth_animated_list: ^1.0.0
```

## Usage

Here's a simple example:

```dart
    SmoothAnimatedList<String>
(
items: ['Item 1', 'Item 2', 'Item 3'],
itemBuilder: (context, item, animation) {
return SlideTransition(
position: Tween<Offset>(
begin: const Offset(1, 0),
end: Offset.zero,
).animate(animation),
child: Card(
child: ListTile(
title: Text(item),
),
),
);
},
);
```

For objects with custom equality:

```dart
class Item {
  final String id;
  final String title;

  Item(this.id, this.title);
}
```

```dart
    SmoothAnimatedList<Item>
(
items: [
Item('1', 'Item 1'),
Item('2', 'Item 2'),
Item('3', 'Item 3'),
],
itemBuilder: (context, item, animation) {
return SlideTransition(
position: Tween<Offset>(
begin: const Offset(1, 0),
end: Offset.zero,
).animate(animation),
child: Card(
child: ListTile(
title: Text(item.title),
),
),
);
},
areItemsTheSame: (oldItem, newItem) => oldItem.
id
==
newItem
.
id
,
);
```

## Additional parameters

- `duration`: Animation duration (default: 300ms)
- `areItemsTheSame`: Custom equality check function

## License

MIT License - see LICENSE file for details