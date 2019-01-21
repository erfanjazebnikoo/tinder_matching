import 'dart:math';

import 'package:Tinder_Matching/util/match_engine.dart';
import 'package:Tinder_Matching/util/anchored_overlay.dart';
import 'package:flutter/material.dart';

class DraggableCard extends StatefulWidget {
  final Widget card;
  final bool isDraggable;
  final bool showOverlay;
  final SlideDirection slideTo;
  final Function(double distance) onSlideUpdate;
  final Function(SlideDirection direction) onSlideOutComplete;

  DraggableCard({
    this.card,
    this.isDraggable = true,
    this.showOverlay = true,
    this.slideTo,
    this.onSlideUpdate,
    this.onSlideOutComplete,
  });

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  Decision _decision;
  GlobalKey _profileCardKey = GlobalKey(debugLabel: 'profile_card_key');
  Offset _cardOffset = const Offset(0.0, 0.0);
  Offset _dragStart;
  Offset _dragPosition;
  Offset _slideBackStart;
  SlideDirection _slideOutDirection;
  AnimationController _slideBackAnimation;
  Tween<Offset> _slideOutTween;
  AnimationController _slideOutAnimation;

  @override
  void initState() {
    super.initState();
    _slideBackAnimation = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() => setState(() {
            _cardOffset = Offset.lerp(
              _slideBackStart,
              const Offset(0.0, 0.0),
              Curves.elasticOut.transform(_slideBackAnimation.value),
            );

            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate(_cardOffset.distance);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _dragStart = null;
            _slideBackStart = null;
            _dragPosition = null;
          });
        }
      });

    _slideOutAnimation = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          _cardOffset = _slideOutTween.evaluate(_slideOutAnimation);

          if (null != widget.onSlideUpdate) {
            widget.onSlideUpdate(_cardOffset.distance);
          }
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _dragStart = null;
            _dragPosition = null;
            _slideOutTween = null;

            if (widget.onSlideOutComplete != null) {
              widget.onSlideOutComplete(_slideOutDirection);
            }
          });
        }
      });
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.card.key != oldWidget.card.key) {
      _cardOffset = const Offset(0.0, 0.0);
    }

    if (oldWidget.slideTo == null && widget.slideTo != null) {
      switch (widget.slideTo) {
        case SlideDirection.left:
          _slideLeft();
          break;
        case SlideDirection.right:
          _slideRight();
          break;
        case SlideDirection.up:
          _slideUp();
          break;
      }
    }
  }

  @override
  void dispose() {
    _slideBackAnimation.dispose();
    super.dispose();
  }

  Offset _chooseRandomDragStart() {
    final cardContext = _profileCardKey.currentContext;
    final cardTopLeft = (cardContext.findRenderObject() as RenderBox)
        .localToGlobal(const Offset(0.0, 0.0));
    final dragStartY = MediaQuery.of(cardContext).size.height *
            (Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
        cardTopLeft.dy;
    return Offset(
        MediaQuery.of(cardContext).size.width / 2 + cardTopLeft.dx, dragStartY);
  }

  void _slideLeft() async {
    final screenWidth = MediaQuery.of(context).size.width;
    _dragStart = _chooseRandomDragStart();
    _slideOutTween = Tween(
        begin: const Offset(0.0, 0.0), end: Offset(-2 * screenWidth, 0.0));
    _slideOutAnimation.forward(from: 0.0);
  }

  void _slideRight() async {
    final screenWidth = MediaQuery.of(context).size.width;
    _dragStart = _chooseRandomDragStart();
    _slideOutTween =
        Tween(begin: const Offset(0.0, 0.0), end: Offset(2 * screenWidth, 0.0));
    _slideOutAnimation.forward(from: 0.0);
  }

  void _slideUp() async {
    final screenHeight = MediaQuery.of(context).size.height;
    _dragStart = _chooseRandomDragStart();
    _slideOutTween = Tween(
        begin: const Offset(0.0, 0.0), end: Offset(0.0, -2 * screenHeight));
    _slideOutAnimation.forward(from: 0.0);
  }

  void _onPanStart(DragStartDetails details) {
    _dragStart = details.globalPosition;

    if (_slideBackAnimation.isAnimating) {
      _slideBackAnimation.stop(canceled: true);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragPosition = details.globalPosition;
      _cardOffset = _dragPosition - _dragStart;

      if (null != widget.onSlideUpdate) {
        widget.onSlideUpdate(_cardOffset.distance);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = _cardOffset / _cardOffset.distance;
    final isInLeftRegion =
        (_cardOffset.dx / MediaQuery.of(context).size.width) < -0.45;
    final isInRightRegion =
        (_cardOffset.dx / MediaQuery.of(context).size.width) > 0.45;
    final isInTopRegion =
        (_cardOffset.dy / MediaQuery.of(context).size.height) < -0.40;

    setState(() {
      if (isInLeftRegion || isInRightRegion) {
        _slideOutTween = Tween(
            begin: _cardOffset,
            end: dragVector * (2 * MediaQuery.of(context).size.width));
        _slideOutAnimation.forward(from: 0.0);

        _slideOutDirection =
            isInLeftRegion ? SlideDirection.left : SlideDirection.right;
      } else if (isInTopRegion) {
        _slideOutTween = Tween(
            begin: _cardOffset,
            end: dragVector * (2 * MediaQuery.of(context).size.height));
        _slideOutAnimation.forward(from: 0.0);

        _slideOutDirection = SlideDirection.up;
      } else {
        _slideBackStart = _cardOffset;
        _slideBackAnimation.forward(from: 0.0);
      }
    });
  }

  double _rotation(Rect dragBounds) {
    if (_dragStart != null) {
      final rotationCornerMultiplier =
          _dragStart.dy >= dragBounds.top + (dragBounds.height / 2) ? -1 : 1;
      return (pi / 8) *
          (_cardOffset.dx / dragBounds.width) *
          rotationCornerMultiplier;
    } else {
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds) {
    if (_dragStart != null) {
      return _dragStart - dragBounds.topLeft;
    } else {
      return const Offset(0.0, 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnchoredOverlay(
      showOverlay: widget.showOverlay,
      child: Center(),
      overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor) {
        return CenterAbout(
          position: anchor,
          child: Transform(
            transform:
                Matrix4.translationValues(_cardOffset.dx, _cardOffset.dy, 0.0)
                  ..rotateZ(_rotation(anchorBounds)),
            origin: _rotationOrigin(anchorBounds),
            child: Container(
              key: _profileCardKey,
              width: anchorBounds.width,
              height: anchorBounds.height,
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onPanStart: _onPanStart,
                onPanUpdate: _onPanUpdate,
                onPanEnd: _onPanEnd,
                child: widget.card,
              ),
            ),
          ),
        );
      },
    );
  }
}

enum SlideDirection {
  left,
  right,
  up,
}
