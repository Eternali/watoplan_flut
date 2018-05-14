import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';

class AboutScreen extends StatefulWidget {

  @override
  State<AboutScreen> createState() => new AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    WatoplanLocalizations locales = WatoplanLocalizations.of(context);

    return new Scaffold(
      appBar: new AppBar(
        leading: new BackButton(),
        centerTitle: true,
        title: new Text(
          WatoplanLocalizations.of(context).aboutTitle
        ),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            new Text(
              locales.aboutFeedback
            )
          ],
        ),
      ),
    );
  }

}
