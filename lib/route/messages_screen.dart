import 'package:Tinder_Matching/util/demo_profiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scaffold_factory/scaffold_factory.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with TickerProviderStateMixin
    implements ScaffoldFactoryBehaviors {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScaffoldFactory _scaffoldFactory;

  @override
  void initState() {
    _initScaffoldFactory();

    super.initState();
  }

  @override
  void dispose() {
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
        titleWidget: Text("Messages"),
      ),
    );
    _scaffoldFactory.scaffoldFactoryBehavior = this;
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 8.0),
        itemCount: demoProfiles.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Slidable(
              delegate: SlidableDrawerDelegate(),
              actionExtentRatio: 0.25,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24.0),
                  ),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: Container(
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(demoProfiles[index].photos[0]),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(24.0),
                      ),
                    ),
                  ),
                  title: Text(demoProfiles[index].name),
                  subtitle: Text('Hello, Nice to meet you!'),
                  trailing: demoProfiles[index].hot
                      ? Icon(
                          Icons.whatshot,
                          color: _scaffoldFactory.colorPalette.primaryColor,
                        )
                      : null,
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'View Profile',
                  color: _scaffoldFactory.colorPalette.accentColor,
                  icon: Icons.person,
                  onTap: () => print('Profile'),
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: _scaffoldFactory.colorPalette.primaryColor,
                  icon: Icons.delete,
                  onTap: () => print('Delete'),
                ),
              ],
            ),
          );
        },
      ),
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
