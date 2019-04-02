import 'package:flutter/material.dart';

import 'package:watoplan/utils/color_utils.dart';

export 'activity_sorters.dart';
export 'activity.dart';
export 'app_state.dart';
export 'filters.dart';
export 'params.dart';

typedef void ContextMethod(BuildContext context);
class MenuChoice {
  final String title;
  final IconData icon;
  final ContextMethod onPressed;
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
    : name = raw[0], color = Color(raw[1]);

  List toJson() {
    return [ name, color.value ];
  }

}

