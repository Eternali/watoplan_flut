import 'package:flutter/material.dart';

import 'package:watoplan/data/models.dart';

final Map<String, HomeLayout> validLayouts = {
  'schedule': new HomeLayout(),
  'month': new HomeLayout(),
};

typedef Widget LayoutBuilder(BuildContext context, AppState state);

class HomeLayout {

  final String name;
  final LayoutBuilder builder;
  final Map<String, dynamic> buildOptions;
  

}

