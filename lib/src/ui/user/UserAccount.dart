import 'package:flutter/material.dart';

class UserAccount extends StatefulWidget {
  @override
  UserAccountState createState() => UserAccountState();
}

class UserAccountState extends State<UserAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            /*  leading: IconButton(
                  icon: Icon(Icons.filter_1),
                  onPressed: () {
                    // Do something
                  }), */
            leading: Container(),
            expandedHeight: 240.0,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 50,
            backgroundColor: Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                title: Text('Ravindran Perumal'),

                /*  Row(
                    children: <Widget>[
                      Image.network(
                        'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50',
                        width: 100,
                        height: 100,
                      ),
                      Column(
                        children: <Widget>[
                          Text('Ravindran Perumal'),
                          Text('+91 9840972275')
                        ],
                      )
                    ],
                  ), */
                background: Image.network(
                  'https://images.pexels.com/photos/443356/pexels-photo-443356.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',
                  fit: BoxFit.cover,
                )),
          ),
          new SliverList(delegate: new SliverChildListDelegate(_buildList(20))),
        ],
      ),
    );
  }

  List _buildList(int count) {
    List<Widget> listItems = List();

    List<String> profileText = [
      'My Family',
      'My Providers',
      'My Family',
      'My Providers',
      'My Family',
      'My Providers'
    ];

    for (int i = 0; i < profileText.length; i++) {
      listItems.add(new Card(
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
        ),
        child: new Padding(
            padding: new EdgeInsets.only(top: 20.0, bottom: 20),
            child: Column(
              children: <Widget>[
                Text(profileText[i], style: new TextStyle(fontSize: 18.0)),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  //color: Colors.yellow,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          //scrollDirection: Axis.horizontal,
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FloatingActionButton(
                              onPressed: () {},
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person_add,
                                color: Colors.deepPurple,
                              ),
                              //elevation: 0,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.withOpacity(0.5),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.withOpacity(0.5),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.withOpacity(0.5),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey.withOpacity(0.5),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      )),
                )
              ],
            )),
      ));
    }

    /*   for (int i = 0; i < count; i++) {
      listItems.add(new Padding(
          padding: new EdgeInsets.all(20.0),
          child: new Text('Item ${i.toString()}',
              style: new TextStyle(fontSize: 25.0))));
    } */

    return listItems;
  }
}
