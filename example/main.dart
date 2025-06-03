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
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey appBarKey = GlobalKey();
  final GlobalKey body1Key = GlobalKey();
  final GlobalKey body2Key = GlobalKey();
  final GlobalKey bottomNav = GlobalKey();

  late final List<GlobalKey> allKeys = <GlobalKey>[
    appBarKey,
    body2Key,
    body1Key,
    bottomNav,
  ];

  @override
  void initState() {
    ExplainFeaturesTutorial(
      widgetKeys: allKeys,
      widgetExplainerText: const <String>[
        'This is the app bar action button',
        'Visit Site text on the body',
        'First Widget on the body',
        'Widget on bottom navigation bar for help',
      ],
      context: context,
    ).showTutorial(delayInSeconds: 10);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        children: <Widget>[
          Text(
            key: bottomNav,
            'Reach out for more help',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
