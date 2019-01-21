import 'dart:async';

import 'package:Tinder_Matching/util/card_stack.dart';
import 'package:Tinder_Matching/util/demo_profiles.dart';
import 'package:Tinder_Matching/util/match_engine.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_factory/scaffold_factory.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin
    implements ScaffoldFactoryBehaviors {
  AnimationController _controller;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScaffoldFactory _scaffoldFactory;
  MatchEngine matchEngine;
  bool _showOverlay;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _initScaffoldFactory();
    this.matchEngine = MatchEngine(
      matches: demoProfiles.map((Profile profile) {
        return DateMatch(profile: profile);
      }).toList(),
    );
    this._showOverlay = true;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scaffoldFactory.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scaffoldFactory.textTheme = Theme.of(context).textTheme;

    return _scaffoldFactory.build(_buildBody(context));
  }

  void _initScaffoldFactory() {
    _scaffoldFactory = ScaffoldFactory(
      scaffoldKey: _scaffoldKey,
      materialPalette: MaterialPalette(
        primaryColor: Colors.deepPurple,
        accentColor: Colors.orangeAccent,
        secondaryColor: Colors.white,
      ),
    );

    _scaffoldFactory.init(
      appBarVisibility: true,
      floatingActionButtonVisibility: false,
      bottomNavigationBarVisibility: false,
      nestedAppBarVisibility: false,
      drawerVisibility: false,
      backgroundType: BackgroundType.solidColor,
      backgroundColor: _scaffoldFactory.colorPalette.secondaryColor,
      appBar: _scaffoldFactory.buildAppBar(
        titleVisibility: true,
        leadingVisibility: false,
        tabBarVisibility: false,
        centerTitle: true,
        backgroundColor: _scaffoldFactory.colorPalette.primaryColor,
        titleWidget: Text("Tinder Matching"),
      ),
    );
    _scaffoldFactory.scaffoldFactoryBehavior = this;
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 8.0,
          left: 0.0,
          right: 0.0,
          bottom: 120.0,
          child: CardStack(
            matchEngine: matchEngine,
            showOverlay: _showOverlay,
            scaffoldFactory: _scaffoldFactory,
          ),
        ),
        Positioned(
          bottom: 64.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RawMaterialButton(
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  matchEngine.currentMatch.nope();
                },
                shape: CircleBorder(),
                elevation: 4.0,
                constraints: BoxConstraints(maxHeight: 56.0),
                padding: EdgeInsets.all(16.0),
                fillColor: _scaffoldFactory.colorPalette.accentColor,
              ),
              SizedBox(width: 12.0),
              RawMaterialButton(
                onPressed: () {
                  matchEngine.currentMatch.superLike();
                },
                child: Icon(
                  Icons.whatshot,
                  color: Colors.deepOrange,
                ),
                shape: CircleBorder(),
                elevation: 4.0,
                constraints: BoxConstraints(maxHeight: 40.0),
                padding: EdgeInsets.all(8.0),
                fillColor: Colors.white,
              ),
              SizedBox(width: 12.0),
              RawMaterialButton(
                onPressed: () {
                  matchEngine.currentMatch.like();
                },
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                shape: CircleBorder(),
                elevation: 4.0,
                constraints: BoxConstraints(maxHeight: 56.0),
                padding: EdgeInsets.all(16.0),
                fillColor: _scaffoldFactory.colorPalette.primaryColor,
              ),
            ],
          ),
        ),
        Positioned(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showOverlay = false;
              });
              Navigator.pushNamed(context, "/message").then((value) {
                Timer(
                  Duration(seconds: 1),
                  () {
                    setState(() {
                      _showOverlay = true;
                    });
                  },
                );
              });
            },
            child: Card(
              elevation: 4.0,
              margin: EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24.0),
                  topLeft: Radius.circular(24.0),
                ),
              ),
              child: Container(
                width: 375.0,
                height: 48.0,
                child: Stack(
                  children: <Widget>[
                    Hero(
                      tag: "messages_box",
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(24.0),
                            topLeft: Radius.circular(24.0),
                          ),
                          color: _scaffoldFactory.colorPalette.primaryColor,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8.0,
                      left: 8.0,
                      right: 0.0,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 16.0),
                          Hero(
                            tag: 'messages_icon',
                            child: Icon(
                              Icons.message,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Hero(
                            tag: "messages_text",
                            child: Text(
                              "Messages",
                              style:
                                  _scaffoldFactory.textTheme.subhead.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottom: 0.0,
          right: 16.0,
          left: 16.0,
        )
      ],
    );
  }

  @override
  void onBackButtonPressed() {
    // TODO: implement onBackButtonPressed
  }

  @override
  Future onEventBusMessageReceived(event) {
    // TODO: implement onEventBusMessageReceived
    return null;
  }

  @override
  void onFloatingActionButtonPressed() {
    // TODO: implement onFloatingActionButtonPressed
  }
}
