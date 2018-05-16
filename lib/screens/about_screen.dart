import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/widgets/link_text_span.dart';

class AboutScreen extends StatefulWidget {

  @override
  State<AboutScreen> createState() => new AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    WatoplanLocalizations locales = WatoplanLocalizations.of(context);
    TextStyle aboutTextSyle = Theme.of(context).textTheme.display1.copyWith(fontSize: 20.0);
    TextStyle linkTextStyle = aboutTextSyle.copyWith(color: Theme.of(context).accentColor);    

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
            new RichText(
              text: new TextSpan(
                children: <TextSpan>[
                  new TextSpan(
                    style: aboutTextSyle,
                    text: '${locales.aboutFeedback} '
                  ),
                  new LinkTextSpan(
                    style: linkTextStyle,
                    url: 'https://github.com/eternali/watoplan_flut/KNOWN_BUGS.md',
                    text: 'known bugs'
                  ),
                  new TextSpan(
                    style: aboutTextSyle,
                    text: ' and '
                  ),
                  new LinkTextSpan(
                    style: linkTextStyle,
                    url: 'https://github.com/eternali/watoplan_flut/TODO.md',
                    text: ' the roadmap '
                  ),
                  new TextSpan(
                    style: aboutTextSyle,
                    text: ' before emailing '
                  ),
                  new LinkTextSpan(
                    style: linkTextStyle,
                    url: 'mailto:chipthinkstudios@gmail.com',
                    text: 'chipthinkstudios@gmail.com',
                    whenCant: () {  },
                  ),
                ]
              ),
            ),
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Divider()
            ),
            new RichText(
              text: new TextSpan(
                children: <TextSpan>[
                  new TextSpan(
                    style: aboutTextSyle,
                    text: '${locales.developFeedback} '
                  ),
                  new LinkTextSpan(
                    style: linkTextStyle,
                    url: 'https://github.com/eternali/watoplan_flut',
                    text: 'github.com/eternali/watoplan_flut',
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }

}
