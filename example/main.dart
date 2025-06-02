import 'package:explain_features_tutorial/explain_features_tutorial.dart';
import 'package:flutter/material.dart';

/// A simple example showing how to use ExplainFeaturesTutorial.
/// this is the application root,
void main() {
  runApp(
    MaterialApp(
      home: const Home(),
      theme: ThemeData.light(),
      title: 'Explain Features Tutorial',
      debugShowCheckedModeBanner: false,
    ),
  );
}

/// this is the home, where all the code is defined.
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<State<StatefulWidget>> appBarKey = GlobalKey();
    final GlobalKey<State<StatefulWidget>> body1Key = GlobalKey();
    final GlobalKey<State<StatefulWidget>> body2Key = GlobalKey();
    final GlobalKey<State<StatefulWidget>> bottomNav = GlobalKey();

    final List<GlobalKey<State<StatefulWidget>>> allKeys =
        <GlobalKey<State<StatefulWidget>>>[
      appBarKey,
      body2Key,
      body1Key,
      bottomNav,
    ];

    return ExplainFeaturesTutorial(
      widgetKeys: allKeys,
      widgetExplainerText: const <String>[
        'This is the app bar action button',
        'Visit Site text on the body',
        'First Widget on the body',
        'Widget on bottom navigation bar for help',
      ],
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              key: appBarKey,
              onPressed: () {},
              icon: const Icon(Icons.local_activity),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                key: body1Key,
                'Developing is fun and cool',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                key: body2Key,
                'Visit my site for work or help: https://king-kibugenza.web.app/',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              key: bottomNav,
              'Reach out for more help',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
