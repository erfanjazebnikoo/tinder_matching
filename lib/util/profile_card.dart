import 'dart:ui';

import 'package:Tinder_Matching/util/demo_profiles.dart';
import 'package:Tinder_Matching/util/photo_browser.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_factory/scaffold_factory.dart';

class ProfileCard extends StatefulWidget {
  final Profile profile;
  final ScaffoldFactory scaffoldFactory;
  final int profileIndex;

  ProfileCard({
    Key key,
    this.profile,
    this.scaffoldFactory,
    this.profileIndex,
  }) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  Widget _buildBackground() {
    return PhotoBrowser(
      photoAssetPaths: widget.profile.photos,
      visiblePhotoIndex: 0,
    );
  }

  Widget _buildProfileSynopsis() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black87,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.profile.name + ", " + widget.profile.age.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    widget.profile.bio,
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0x11000000),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: Material(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _buildBackground(),
              _buildProfileSynopsis(),
            ],
          ),
        ),
      ),
    );
  }
}
