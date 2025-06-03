library explain_features_tutorial;

import 'package:flutter/material.dart'
    show
        Animation,
        AnimationController,
        AppBar,
        Border,
        BorderRadius,
        BoxDecoration,
        BuildContext,
        Canvas,
        Center,
        Color,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        Curve,
        CurvedAnimation,
        Curves,
        CustomPaint,
        CustomPainter,
        EdgeInsets,
        FadeTransition,
        GlobalKey,
        Icon,
        IconButton,
        Icons,
        InkWell,
        MainAxisAlignment,
        MainAxisSize,
        Material,
        MaterialApp,
        MediaQuery,
        Offset,
        Overlay,
        OverlayEntry,
        Padding,
        Paint,
        PaintingStyle,
        Path,
        PathFillType,
        Positioned,
        RRect,
        Radius,
        Rect,
        RenderBox,
        Row,
        Scaffold,
        Size,
        SizedBox,
        SlideTransition,
        Spacer,
        Stack,
        State,
        StatefulWidget,
        StatelessWidget,
        Text,
        TextStyle,
        ThemeData,
        TickerProviderStateMixin,
        Tween,
        Widget,
        WidgetsBinding,
        runApp;
import 'dart:async' show Future, Timer;
import 'package:flutter/foundation.dart' show kDebugMode;

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
    final GlobalKey appBarKey = GlobalKey();
    final GlobalKey body1Key = GlobalKey();
    final GlobalKey body2Key = GlobalKey();
    final GlobalKey bottomNav = GlobalKey();

    final List<GlobalKey> allKeys = <GlobalKey>[
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
          children: <Widget>[
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
//! package starts from here,

/// this constants defines the bubble height,
const double _bubbleHeight = 170;

/// defines the bubble width
const double _bubbleWidth = 270;

/// A simple widget that adds a fade and slide-in animation to its child.
/// Used internally by the tutorial overlay to animate widgets into view.
class _AnimateViews extends StatefulWidget {
  const _AnimateViews({
    required this.delayInMilliseconds,
    required this.child,
    this.curve = Curves.decelerate,
  });

  /// widget to animate,
  final Widget child;

  /// delay in milliseconds,
  final int delayInMilliseconds;

  /// curve,
  final Curve curve;

  @override
  _AnimateViewsState createState() => _AnimateViewsState();
}

class _AnimateViewsState extends State<_AnimateViews>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final CurvedAnimation curve = CurvedAnimation(
      curve: widget.curve,
      parent: _animController,
    );

    _animOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
            .animate(curve);

    // Delay the animation to create a staggered appearance effect.
    timer = Timer(Duration(milliseconds: widget.delayInMilliseconds), () {
      _animController.forward();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _animController,
        child: SlideTransition(
          position: _animOffset,
          child: widget.child,
        ),
      );
}

/// This widget displays a tutorial overlay highlighting widgets by their GlobalKeys.
/// It draws a spotlight around the target and shows text explaining its purpose.
class ExplainFeaturesTutorial extends StatefulWidget {
  const ExplainFeaturesTutorial({
    required this.widgetKeys,
    required this.widgetExplainerText,
    required this.child,
    this.cancelText = 'Cancel',
    this.next = 'Next',
    this.showCancelButton = true,
    this.targetObserverColor = const Color.fromARGB(255, 171, 71, 188),
    this.showTutorial = true,
    this.delayInSeconds = 10,
    super.key,
  });

  /// List of keys pointing to widgets that will be focused one by one.
  final List<GlobalKey> widgetKeys;

  /// Corresponding explainer texts shown with each widget.
  final List<String> widgetExplainerText;

  /// The main child of this widget.
  final Widget child;

  /// Text for the cancel button.
  final String cancelText;

  /// Whether to show the cancel button.
  final bool showCancelButton;

  /// Text for next,
  final String next;

  /// target observer color, like the bubble and the decoration,
  final Color targetObserverColor;

  /// this bool determines if the tutorial will show or not??
  ///
  /// if [true] = showing,
  ///
  /// else, not showing.
  final bool showTutorial;

  /// these are seconds to delay before showing tutorial, it help to wait for every widget to paint. like if you have some widgets that maybe only paint after fetching some data online...
  ///
  /// adjust accordingly,
  final int delayInSeconds;

  @override
  State<ExplainFeaturesTutorial> createState() =>
      _ExplainFeaturesTutorialState();
}

class _ExplainFeaturesTutorialState extends State<ExplainFeaturesTutorial> {
  OverlayEntry? _overlayEntry;
  int _step = 0;

  @override
  void initState() {
    super.initState();

    /// immediately return if show tutorial is false,
    if (!widget.showTutorial) return;

    // Begin showing the tutorial after the widget tree has been built.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(
        Duration(seconds: widget.delayInSeconds),
      );
      _showTutorial();
    });
  }

  /// Inserts an overlay for the current step.
  void _showTutorial() {
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Advances to the next step, or cancels if requested or finished.
  void _nextStep({bool cancel = false}) {
    _overlayEntry?.remove();
    _step++;

    if (cancel || _step == widget.widgetKeys.length) return;
    _showTutorial();
  }

  /// Builds the current step's overlay entry.
  OverlayEntry? _buildOverlay() {
    final BuildContext? currentContext =
        widget.widgetKeys[_step].currentContext;

    // Handle case where key context is not found.
    if (currentContext == null) {
      if (kDebugMode) {
        print('context is null, check if the widget is in the tree properly');
      }
      return null;
    }

    final RenderBox targetBox = currentContext.findRenderObject() as RenderBox;
    final Offset targetOffset = targetBox.localToGlobal(Offset.zero);
    final Size targetSize = targetBox.size;

    return OverlayEntry(
      builder: (_) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              // Dim the screen and spotlight the widget
              _AnimateViews(
                curve: Curves.easeIn,
                delayInMilliseconds: 200,
                child: _SpotlightOverlay(
                  targetOffset: targetOffset,
                  targetSize: targetSize,
                ),
              ),

              // Highlighted border around the current widget
              Positioned(
                left: targetOffset.dx - 8,
                top: targetOffset.dy - 8,
                child: InkWell(
                  onTap: _nextStep,
                  child: _AnimateViews(
                    delayInMilliseconds: 500,
                    child: Container(
                      width: targetSize.width + 16,
                      height: targetSize.height + 16,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.transparent,
                        border: Border.all(
                          color: widget.targetObserverColor,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// bubble to show on the message,
              _messageBubble(
                context: context,
                targetOffset: targetOffset,
                targetSize: targetSize,
                targetObserverColor: widget.targetObserverColor,
                child: SizedBox(
                  height: _bubbleHeight,
                  width: _bubbleWidth,
                  child: Column(
                    children: <Widget>[
                      _AnimateViews(
                        delayInMilliseconds: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.widgetExplainerText.elementAtOrNull(_step) ??
                                '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            maxLines: 3,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // only show if it's true else next will be used alone,
                          if (widget.showCancelButton)
                            _AnimateViews(
                              delayInMilliseconds: 1500,
                              child: InkWell(
                                onTap: () => _nextStep(cancel: true),
                                child: Container(
                                  padding: const EdgeInsets.all(6.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red.withOpacity(0.3),
                                  ),
                                  child: Text(
                                    widget.cancelText,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(width: 10),
                          _AnimateViews(
                            delayInMilliseconds: 500,
                            child: InkWell(
                              onTap: _nextStep,
                              child: Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue.withOpacity(0.3),
                                ),
                                child: Text(
                                  widget.next,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// A custom widget that paints a dark overlay with a cut-out highlight
/// around the current widget being focused.
class _SpotlightOverlay extends StatelessWidget {
  const _SpotlightOverlay({
    required this.targetOffset,
    required this.targetSize,
  });

  final Offset targetOffset;
  final Size targetSize;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: MediaQuery.of(context).size,
        painter: _SpotlightPainter(targetOffset, targetSize),
      );
}

/// The painter responsible for drawing the spotlight effect.
class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter(this.targetOffset, this.targetSize);

  final Offset targetOffset;
  final Size targetSize;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final Rect holeRect = Rect.fromLTWH(
      targetOffset.dx - 8,
      targetOffset.dy - 8,
      targetSize.width + 16,
      targetSize.height + 16,
    );

    final Path backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final Path holePath = Path()
      ..addRRect(RRect.fromRectAndRadius(holeRect, const Radius.circular(12)))
      ..close();

    // Create the spotlight by subtracting the target area using even-odd fill.
    backgroundPath.addPath(holePath, Offset.zero);
    backgroundPath.fillType = PathFillType.evenOdd;

    canvas.drawPath(backgroundPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// this is a message bubble drawer, it is used to position the bubble correctly on screen according to the position of the focused widget
Widget _messageBubble({
  required BuildContext context,
  required Offset targetOffset,
  required Size targetSize,
  required Widget child,
  required Color targetObserverColor,
}) {
  final double screenHeight = MediaQuery.of(context).size.height;
  final double screenWidth = MediaQuery.of(context).size.width;

  const double padding = 15.0;
  const double tooltipWidth = 250.0;

  final bool isNearTop = targetOffset.dy < screenHeight * 0.25;
  final bool isNearBottom = targetOffset.dy > screenHeight * 0.75;

  bool showBelow;

  if (isNearTop) {
    showBelow = true;
  } else if (isNearBottom) {
    showBelow = false;
  } else {
    // Middle zone – decide based on space available
    final double spaceAbove = targetOffset.dy;
    final double spaceBelow =
        screenHeight - (targetOffset.dy + targetSize.height);

    showBelow = spaceBelow > spaceAbove;
  }

  double top = showBelow
      ? targetOffset.dy + targetSize.height + padding
      : targetOffset.dy - _bubbleWidth - padding;

  // Prevent tooltip from going off-screen horizontally
  double left = targetOffset.dx;

  if (left + tooltipWidth > screenWidth) {
    left = screenWidth - tooltipWidth - (padding * 3);
  } else if (left < padding) {
    left = padding;
  }

  return Positioned(
    top: top,
    left: left,
    child: CustomPaint(
      size: const Size(_bubbleWidth, _bubbleHeight),
      painter: _SpeechBubblePainter(targetObserverColor),
      child: child,
    ),
  );
}

/// this is a speech bubble class for smoothness,
class _SpeechBubblePainter extends CustomPainter {
  _SpeechBubblePainter(this.targetObserverColor);

  final Color targetObserverColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = targetObserverColor
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final Path path = Path();

    // Start top-left and move clockwise
    path.moveTo(20, 0);
    path.quadraticBezierTo(0, 0, 0, 20); // Top-left curve
    path.lineTo(0, size.height - 40); // Left side
    path.quadraticBezierTo(
      0,
      size.height,
      30,
      size.height,
    ); // Bottom-left curve

    // Tail to show like it's a message
    path.lineTo(50, size.height);
    path.lineTo(20, size.height + 30);
    path.lineTo(90, size.height);

    // Bottom-right and up
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 20); // Right side
    path.quadraticBezierTo(
      size.width,
      0,
      size.width - 20,
      0,
    ); // Top-right curve
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
