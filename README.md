<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# explain_features_tutorial

A lightweight Flutter package to visually guide users through your app by highlighting specific widgets step-by-step. 
Perfect for onboarding flows or feature discovery.
- 🔗 full source code Url: [Source Url](https://king-kibugenza.web.app/explain_features_tutorial.html)

Easily explain parts of your UI using customizable overlays and animations — no native dependencies, and it's very light.
The reason i made this package, the ones on pub.dev were extremely slow on the web and on low-resources devices also crashed all the time.

if you find this project useful, consider [Buy Me A Coffee](https://coff.ee/kibugenza), Thanks...

## Features

- 🔍 Highlight any widget using its `GlobalKey`
- ✨ Smooth fade and slide-in animations for guidance
- 🧭 Step-by-step navigation through key UI elements
- ❌ Optional cancel button to skip the tutorial
- 🧱 100% Flutter — no platform channels or native code
- 📦 Lightweight and easy to integrate

![GIF showing Usage](https://firebasestorage.googleapis.com/v0/b/indrive-clone-520d9.appspot.com/o/explain_features_tutorial.webp?alt=media&token=58dba180-56c8-4d11-a640-00e2934843d9)


## Getting started

To start using `explain_features_tutorial`, simply add it to your `pubspec.yaml`:

```yaml
dependencies:
  explain_features_tutorial: ^0.1.1
```

Then run: 
```bash
    flutter pub get
```

and import the package where needed: 

```dart
import 'package:explain_features_tutorial/explain_features_tutorial.dart';
```

## Usage

Wrap your app (or a specific screen) with `ExplainFeaturesTutorial` and pass in:

- a list of `GlobalKey`s for the widgets you want to highlight
- matching `widgetExplainerText` to describe each widget

Here's a minimal example:

```dart
final GlobalKey<State<StatefulWidget>> buttonKey = GlobalKey();
final GlobalKey<State<StatefulWidget>> textKey = GlobalKey();

final List<GlobalKey<State<StatefulWidget>>> allKeys = [
  buttonKey,
  textKey,
];

ExplainFeaturesTutorial(
  widgetKeys: allKeys,
  widgetExplainerText: const [
    'This is the action button',
    'This is some important text',
  ],
  child: Scaffold(
    appBar: AppBar(
      actions: [
        IconButton(
          key: buttonKey,
          icon: Icon(Icons.star),
          onPressed: () {},
        ),
      ],
    ),
    body: Center(
      child: Text(
        'Welcome!',
        key: textKey,
        style: TextStyle(fontSize: 20),
      ),
    ),
  ),
);
```

## Additional information

This package was built to provide a lightweight, customizable way to guide users through your Flutter app’s features — especially useful for walkthroughs.
If you run into any bugs or want to suggest improvements, feel free to reach on [my website](https://king-kibugenza.web.app/) for help.
More customization options and enhancements (like tooltips, shapes, or progress indicators) may be added in future updates.
