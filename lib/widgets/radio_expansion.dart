// This is a modified version of the ExpansionTile build by the Flutter team,
// which can be found here: https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/expansion_tile.dart
// I just changed it to behave a little more like an ExpansionPanel,
// but still have the UI customization capabilities of an ExpansionTile.
// Oh and yeah, it can be a radio button too.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';  // apparently I need this on linux, though it works fine on mac without.

const Duration _kExpand = const Duration(milliseconds: 200);

typedef Future ExpansionChanged<T>(T value);

/// A single-line [RadioExpansion] with a trailing button that expands or collapses
/// the tile to reveal or hide the [children].
///
/// This widget is typically used with [ListView] to create an
/// "expand / collapse" list entry. When used with scrolling widgets like
/// [ListView], a unique [PageStorageKey] must be specified to enable the
/// [ExpansionTile] to save and restore its expanded state when it is scrolled
/// in and out of view.
///
/// See also:
///
///  * [ListTile], useful for creating expansion tile [children] when the
///    expansion tile represents a sublist.
///  * The "Expand/collapse" section of
///    <https://material.io/guidelines/components/lists-controls.html>.
class RadioExpansion<T> extends StatefulWidget {
  /// Creates a single-line [ListTile] with a trailing button that expands or collapses
  /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  /// be non-null.
  const RadioExpansion({
    Key key,
    this.leading,
    this.title,
    this.backgroundColor,
    this.children = const <Widget>[],
    this.trailing,
    @required this.onChanged,
    @required this.value,
    @required this.groupValue,
  }) : super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget leading;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget> children;

  /// The color to display behind the sublist when expanded.
  final Color backgroundColor;

  /// A widget to display instead of a rotating arrow icon.
  final Widget trailing;

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for this group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T groupValue;

  bool get checked => value == groupValue;

  /// Called when the tile is tapped. If a value other than null is returned,
  /// the widget will set it to be its new group value and rebuild.
  final ExpansionChanged<T> onChanged;

  @override
  _RadioExpansionState createState() => new _RadioExpansionState<T>(value, groupValue);
}


class _RadioExpansionState<T> extends State<RadioExpansion> with SingleTickerProviderStateMixin {

  _RadioExpansionState(this.value, this.groupValue);

  T value;
  T groupValue;
  bool get isExpanded => value == groupValue;
  AnimationController _controller;
  CurvedAnimation _easeOutAnimation;
  CurvedAnimation _easeInAnimation;
  ColorTween _borderColor;
  ColorTween _headerColor;
  ColorTween _iconColor;
  ColorTween _backgroundColor;
  Animation<double> _iconTurns;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(duration: _kExpand, vsync: this);
    _easeOutAnimation = new CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _easeInAnimation = new CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _borderColor = new ColorTween();
    _headerColor = new ColorTween();
    _iconColor = new ColorTween();
    _iconTurns = new Tween<double>(begin: 0.0, end: 0.5).animate(_easeInAnimation);
    _backgroundColor = new ColorTween();

    if (isExpanded)
      _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onChanged(value)
      .then((_) =>
        setState(() {
          if (isExpanded)
            _controller.forward();
          else
            _controller.reverse().then<void>((Null value) {
              setState(() {
                // Rebuild without widget.children.
              });
            });
        })
      );
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color borderSideColor = _borderColor.evaluate(_easeOutAnimation) ?? Colors.transparent;
    final Color titleColor = _headerColor.evaluate(_easeInAnimation);

    return new Container(
      decoration: new BoxDecoration(
        color: _backgroundColor.evaluate(_easeOutAnimation) ?? Colors.transparent,
        border: new Border(
          top: new BorderSide(color: borderSideColor),
          bottom: new BorderSide(color: borderSideColor),
        )
      ),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data: new IconThemeData(color: _iconColor.evaluate(_easeInAnimation)),
            child: new ListTile(
              onTap: _handleTap,
              leading: widget.leading,
              title: new DefaultTextStyle(
                style: Theme.of(context).textTheme.subhead.copyWith(color: titleColor),
                child: widget.title,
              ),
              trailing: widget.trailing ?? new RotationTransition(
                turns: _iconTurns,
                child: const Icon(Icons.expand_more),
              ),
            ),
          ),
          new ClipRect(
            child: new Align(
              heightFactor: _easeInAnimation.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    _borderColor.end = theme.dividerColor;
    _headerColor
      ..begin = theme.textTheme.subhead.color
      ..end = theme.accentColor;
    _iconColor
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _backgroundColor.end = widget.backgroundColor;

    final bool closed = !isExpanded && _controller.isDismissed;
    return new AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : new Column(children: widget.children),
    );

  }
}