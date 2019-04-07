import 'package:flutter/material.dart';

import 'package:watoplan/utils/color_utils.dart';

export 'activity_sorters.dart';
export 'activity.dart';
export 'app_state.dart';
export 'filters.dart';
export 'params.dart';

class MenuChoice {
  final String title;
  final IconData icon;
  final Function onPressed;
  const MenuChoice({
    this.title,
    this.icon,
    this.onPressed,
  });
}

typedef dynamic JsonConverter(dynamic value);

class Tag {

  final String name;
  final Color color;

  Tag(this.name, { Color color }) : this.color = color ?? intToColor(name.hashCode);

  Tag.fromJson(List raw)
    : name = raw[0], color = raw.length > 1 ? Color(raw[1]) : intToColor(raw[0].hashCode);

  List toJson() {
    return [ name, color.value ];
  }

}

