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

if you find this project useful, consider [Buy Me A Coffee](https://buymeacoffee.com/kibugenza), Thanks...

## Features

- 🔍 Highlight any widget using its `GlobalKey`
- ✨ Smooth fade and slide-in animations for guidance
- 🧭 Step-by-step navigation through key UI elements
- 🧱 100% Flutter — no platform channels or native code
- 📦 Lightweight and easy to integrate

![GIF showing Usage](https://firebasestorage.googleapis.com/v0/b/indrive-clone-520d9.appspot.com/o/explain_features_tutorial_v0.1.2.webp?alt=media&token=b242ce72-a589-4e1b-a70e-e8977f92e07f)

## Parameters
- required List of GlobalKey: widgetKeys
- required List of String: widgetExplainerText
- required BuildContext context
- String cancelText = "Cancel", 
- String next = 'Next',
- bool showCancelButton = true
- bool disableButtonDelayAnimations = false
-  String lastButtonText = 'Okay',
- Color targetObserverColor = const Color.fromARGB(255, 171, 71,188),

## Getting started

To start using `explain_features_tutorial`, simply add it to your `pubspec.yaml`:

```yaml
dependencies:
  explain_features_tutorial: ^0.2.3
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

Call `ExplainFeaturesTutorial(parameters).showTutorial()` as a function inside initState:

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

// then simply call, 
// it's a function, call it from InitState of a stateful widget, 
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
```

## Additional information

This package was built to provide a lightweight, customizable way to guide users through your Flutter app’s features — especially useful for walkthroughs.
If you run into any bugs or want to suggest improvements, feel free to reach on [my website](https://king-kibugenza.web.app/) for help.
More customization options and enhancements (like tooltips, shapes, or progress indicators) may be added in future updates.
