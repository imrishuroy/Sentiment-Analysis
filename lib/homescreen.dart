import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIservice {
  static const apikey = 'ee98872aefmsh6569140441850f9p1f6f0djsn2d0353056515';
  static const baseURl =
      'https://twinword-twinword-bundle-v1.p.rapidapi.com/word_associations/';
  static const Map<String, String> header = {
    "content-type": "application/x-www-form-urlencoded",
    "x-rapidapi-key": apikey,
    "x-rapidapi-host": "twinword-twinword-bundle-v1.p.rapidapi.com",
    "useQueryString": "true",
  };

  Future<SentAna> post({@required Map<String, String> query}) async {
    final response = await http.post(baseURl, headers: header, body: query);

    if (response.statusCode == 200) {
      print('Success' + response.body);
      return SentAna.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class SentAna {
  final String emotions;
  SentAna({this.emotions});

  factory SentAna.fromJson(Map<String, dynamic> json) {
    return SentAna(emotions: json['emotions_detected'][0]);
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  final mycontroller = TextEditingController();

  APIservice apiservice = APIservice();
  Future<SentAna> analysis;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.004, 1],
            colors: [
              Color(0xffe100ff),
              Color(0xff8e2de2),
            ],
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 4.5),
              Text(
                'Sentiment Analysis',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      child: Center(
                        child: _loading
                            ? Container(
                                width: 300,
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: mycontroller,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      decoration: InputDecoration(
                                          labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 21,
                                          ),
                                          labelText: 'Enter a search term'),
                                    ),
                                    SizedBox(height: 30),
                                  ],
                                ),
                              )
                            : Container(),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // _loading = false;
                                print(mycontroller.text);
                                analysis = apiservice
                                    .post(query: {'text': mycontroller.text});
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 180,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 17,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xff56ab2f),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Find Emotions',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          FutureBuilder<SentAna>(
                            future: analysis,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  'Predection is : ' + snapshot.data.emotions,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 29.0,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// BKscdk080#

// @Pxjkks910
