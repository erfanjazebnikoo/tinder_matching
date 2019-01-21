import 'package:Tinder_Matching/util/match_engine.dart';
import 'package:Tinder_Matching/util/draggable_card.dart';
import 'package:Tinder_Matching/util/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_factory/scaffold_factory.dart';

class CardStack extends StatefulWidget {
  final MatchEngine matchEngine;
  final bool showOverlay;
  final ScaffoldFactory scaffoldFactory;

  CardStack({
    this.matchEngine,
    this.showOverlay,
    this.scaffoldFactory,
  });

  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  Key _frontCard;
  DateMatch _currentMatch;
  double _nextCardScale = 0.9;
  bool _showOverlay = true;

  @override
  void initState() {
    super.initState();
    widget.matchEngine.addListener(_onMatchEngineChange);

    _currentMatch = widget.matchEngine.currentMatch;
    _currentMatch.addListener(_onMatchChange);

    _frontCard = Key(_currentMatch.profile.name);
  }

  @override
  void didUpdateWidget(CardStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.matchEngine != oldWidget.matchEngine) {
      oldWidget.matchEngine.removeListener(_onMatchEngineChange);
      widget.matchEngine.addListener(_onMatchEngineChange);

      if (_currentMatch != null) {
        _currentMatch.removeListener(_onMatchChange);
      }
      _currentMatch = widget.matchEngine.currentMatch;
      if (_currentMatch != null) {
        _currentMatch.addListener(_onMatchChange);
      }
    }
  }

  @override
  void dispose() {
    if (_currentMatch != null) {
      _currentMatch.removeListener(_onMatchChange);
    }

    widget.matchEngine.removeListener(_onMatchEngineChange);

    super.dispose();
  }

  void _onMatchEngineChange() {
    if (_currentMatch != null) {
      _currentMatch.removeListener(_onMatchChange);
    }
    _currentMatch = widget.matchEngine.currentMatch;
    if (_currentMatch != null) {
      _currentMatch.addListener(_onMatchChange);
    }

    _frontCard = Key(_currentMatch.profile.name);

    setState(() {});
  }

  void _onMatchChange() {
    setState(() {
      /* current match may have changed state, re-render */
    });
  }

  Widget _buildBackCard() {
    return Transform(
      transform: Matrix4.identity()..scale(_nextCardScale, _nextCardScale),
      alignment: Alignment.center,
      child: ProfileCard(
        scaffoldFactory: widget.scaffoldFactory,
        profile: widget.matchEngine.nextMatch.profile,
        profileIndex: widget.matchEngine.nextMatchIndex,
      ),
    );
  }

  Widget _buildFrontCard() {
    return ProfileCard(
      key: _frontCard,
      profile: widget.matchEngine.currentMatch.profile,
      scaffoldFactory: widget.scaffoldFactory,
      profileIndex: widget.matchEngine.currentMatchIndex,
    );
  }

  SlideDirection _desiredSlideOutDirection() {
    switch (widget.matchEngine.currentMatch.decision) {
      case Decision.nope:
        return SlideDirection.left;
      case Decision.like:
        return SlideDirection.right;
      case Decision.superLike:
        return SlideDirection.up;
      default:
        return null;
    }
  }

  void _onSlideUpdate(double distance) {
    setState(() {
      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  void _onSlideOutComplete(SlideDirection direction) {
    DateMatch currentMatch = widget.matchEngine.currentMatch;

    switch (direction) {
      case SlideDirection.left:
        currentMatch.nope();
        break;
      case SlideDirection.right:
        currentMatch.like();
        break;
      case SlideDirection.up:
        currentMatch.superLike();
        break;
    }

    widget.matchEngine.cycleMatch();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DraggableCard(
          card: _buildBackCard(),
          isDraggable: false,
          showOverlay: widget.showOverlay & _showOverlay,
        ),
        DraggableCard(
          card: _buildFrontCard(),
          slideTo: _desiredSlideOutDirection(),
          onSlideUpdate: _onSlideUpdate,
          onSlideOutComplete: _onSlideOutComplete,
          showOverlay: widget.showOverlay & _showOverlay,
        ),
      ],
    );
  }
}
