import 'package:flutter/material.dart';

class HomeDashBoard extends StatefulWidget {
  @override
  _HomeDashBoardState createState() => _HomeDashBoardState();
}

class _HomeDashBoardState extends State<HomeDashBoard> {

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text("Dashboard")),
        body: SingleChildScrollView (
          child: Column (
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('asset/images/app_logo.png'))
              ),
              GridView.count(
                  shrinkWrap: true,
                  childAspectRatio: MediaQuery.of(context).size.height / 400,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  crossAxisCount: 2,
            children: List.generate(choices.length, (index) {
              return Center(
                child: SelectCard(choice: choices[index]),
              );
            }
            )
          )
            ],
          ),
        ),
        drawer: Container (
           height: MediaQuery.of(context).size.height * 0.8,
          child: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
              dense: true,
                title: Text('Home'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                dense: true,
                title: Text('Inspections'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(left: 30.0),
                title: Text('Unassigned'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(left: 30.0),
                title: Text('Assigned'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(left: 30.0),
                title: Text('Scheduled'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(left: 30.0),
                title: Text('On-Hold'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(left: 30.0),
                title: Text('In-Progress'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(left: 30.0),
                title: Text('Ready to Review'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(left: 30.0),
                title: Text('Completed'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                dense: true,
                title: Text('Logoff'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Divider()
            ],
          ),
        ),
        )
      );
    }
}


class Choice {
  const Choice({this.title, this.count});
  final String title;
  final int count;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Unassigned', count: 0),
  const Choice(title: 'Assigned', count: 0),
  const Choice(title: 'Scheduled', count: 0),
  const Choice(title: 'On-Hold', count: 0),
  const Choice(title: 'In-Progress', count: 0),
  const Choice(title: 'Ready to Review', count: 0),
  const Choice(title: 'Completed', count: 0),
];

class SelectCard extends StatelessWidget {
  const SelectCard({Key key, this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    return Container(
     height: 120,
      child:Card(
        shape: Border(
                top: BorderSide(width: 0.0, color: Colors.black),
                left: BorderSide(width: 0.0, color: Colors.black),
                 right: BorderSide(width: 0.0, color: Colors.black),
                 bottom: BorderSide(width: 0.0, color: Colors.black),
               ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  choice.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
               Divider(color: Colors.black),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                  choice.count.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ]
        ),
        )
    ));
  }
}
