import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myfhb/src/search/SearchSpecificList.dart';
import 'package:myfhb/widgets/RaisedGradientButton.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({
    Key key,
    @required this.imagePath,
  }) : super(key: key);

  @override
  DisplayPictureScreenState createState() => DisplayPictureScreenState();
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {
  TextEditingController doctorsName = new TextEditingController();
  TextEditingController hospitalName = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              height: double.infinity,
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Container(
            child: RaisedGradientButton(
              child: Text(
                'Done',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              gradient: LinearGradient(
                colors: <Color>[Colors.deepPurple[300], Colors.deepPurple],
              ),
              onPressed: () {
                saveMediaDialog(context);
              },
            ),
          )
        ],
      ),
    );
  }

  saveMediaDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Save Record',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.deepPurple),
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Text(
                            'Doctor Name *',
                            style: TextStyle(fontSize: 14),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: TextField(
                            autofocus: false,
                            onTap: () {
                              moveToSearchScreen(context, 'Doctors');
                            },
                            controller: doctorsName,
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Text(
                            'File Name *',
                            style: TextStyle(fontSize: 14),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: TextField(
                            autofocus: false,
                            onTap: () {
                              moveToSearchScreen(context, '');
                            },
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Text(
                            'Hospital Name *',
                            style: TextStyle(fontSize: 14),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: TextField(
                            autofocus: false,
                            onTap: () {
                              moveToSearchScreen(context, 'Hospitals');
                            },
                            controller: hospitalName,
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Text(
                            'Date of visit *',
                            style: TextStyle(fontSize: 14),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: TextField(
                            autofocus: false,
                            onTap: () {
                              moveToSearchScreen(context, '');
                            },
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.calendar_today)),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: Text(
                            'Message',
                            style: TextStyle(fontSize: 14),
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width - 60,
                          child: TextField(
                            autofocus: false,
                            onTap: () {
                              moveToSearchScreen(context, '');
                            },
                          )),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
              RaisedGradientButton(
                width: 120,
                height: 40,
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                borderRadius: 30,
                gradient: LinearGradient(
                  colors: <Color>[Colors.deepPurple[300], Colors.deepPurple],
                ),
                onPressed: () {},
              )
            ],
          ),
        );
      },
    );
  }

  Future moveToSearchScreen(BuildContext context, String searchParam) async {
    Map results = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SearchSpecificList(searchParam)));

    if (results != null) {
      if (results.containsKey('doctor')) {
        doctorsName = new TextEditingController(text: results['doctor']);
      } else if (results.containsKey('hospital')) {
        hospitalName = new TextEditingController(text: results['hospital']);
      }
      setState(() {});
    }
  }
}
