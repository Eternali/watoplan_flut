import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/data/models.dart';

class AboutScreen extends StatefulWidget {

  @override
  State<AboutScreen> createState() => new AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(),
        centerTitle: true,
        title: new Text(
          WatoplanLocalizations.of(context).aboutTitle
        ),
      ),
    );
  }

}
