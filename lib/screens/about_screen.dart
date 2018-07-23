import 'package:flutter/material.dart';

import 'package:watoplan/localizations.dart';
import 'package:watoplan/widgets/link_text_span.dart';

class AboutScreen extends StatefulWidget {

  @override
  State<AboutScreen> createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    final locales = WatoplanLocalizations.of(context);
    final TextStyle aboutTextSyle = Theme.of(context).textTheme.display1.copyWith(fontSize: 20.0);
    final TextStyle linkTextStyle = aboutTextSyle.copyWith(color: Theme.of(context).accentColor);    

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        centerTitle: true,
        title: Text(
          WatoplanLocalizations.of(context).aboutTitle
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      style: aboutTextSyle,
                      text: '${locales.aboutFeedback} '
                    ),
                    LinkTextSpan(
                      style: linkTextStyle,
                      url: 'https://github.com/Eternali/watoplan_flut/blob/release/KNOWN_BUGS.md',
                      text: 'known bugs'
                    ),
                    TextSpan(
                      style: aboutTextSyle,
                      text: ' and '
                    ),
                    LinkTextSpan(
                      style: linkTextStyle,
                      url: 'https://github.com/Eternali/watoplan_flut/blob/release/TODO.md',
                      text: 'the roadmap'
                    ),
                    TextSpan(
                      style: aboutTextSyle,
                      text: ' before emailing '
                    ),
                    LinkTextSpan(
                      style: linkTextStyle,
                      url: 'mailto:chipthinkstudios@gmail.com',
                      text: 'chipthinkstudios@gmail.com',
                      whenCant: () {  },
                    ),
                  ]
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Divider()
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      style: aboutTextSyle,
                      text: '${locales.developFeedback} '
                    ),
                    LinkTextSpan(
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
      ),
    );
  }

}
