library explain_features_tutorial;

import 'dart:async';
import 'package:flutter/material.dart';

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
    super.key,
  });

  /// List of keys pointing to widgets that will be focused one by one.
  final List<GlobalKey<State<StatefulWidget>>> widgetKeys;

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
    // Begin showing the tutorial after the widget tree has been built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
  OverlayEntry _buildOverlay() {
    final BuildContext? currentContext =
        widget.widgetKeys[_step].currentContext;

    // Handle case where key context is not found.
    if (currentContext == null) {
      return OverlayEntry(
        builder: (_) => Material(
          color: Colors.red.withOpacity(0.6),
          child: const Center(
            child: Text(
              'Context is missing...',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      );
    }

    final RenderBox targetBox = currentContext.findRenderObject() as RenderBox;
    final Offset targetOffset = targetBox.localToGlobal(Offset.zero);
    final Size targetSize = targetBox.size;

    return OverlayEntry(
      builder: (_) => Material(
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
                      border: Border.all(color: Colors.blue, width: 8),
                    ),
                  ),
                ),
              ),
            ),

            // Explanation text and optional cancel button
            Center(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _AnimateViews(
                        delayInMilliseconds: 300,
                        child: Container(
                          width: 250,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.widgetExplainerText.elementAtOrNull(_step) ??
                                '',
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                            maxLines: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // only show if it's true

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _SpotlightPainter(targetOffset, targetSize),
    );
  }
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
