import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'admin.dart';
import 'anggota.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Welcome",
        home: new HomePage(),
        routes: <String, WidgetBuilder>{
          'Admin': (BuildContext context) => new Admin(),
          'Member': (BuildContext context) => new Anggota()
        });
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController usr = TextEditingController();
  TextEditingController pass = TextEditingController();

  String msg = '';

  Future<List> _login() async {
    final response = await http.post("http://192.168.134.1/api/login.php",
        body: {"username": usr.text, "password": pass.text});
    var datauser = json.decode(response.body);
    if (datauser.length == 0) {
      setState(() {
        msg = "Login Failed";
      });
    } else {
      if (datauser[0]['level'] == 'admin') {
        Navigator.pushReplacementNamed(context, 'Admin');
      } else if (datauser[0]['level'] == 'anggota') {
        Navigator.pushReplacementNamed(context, 'Anggota');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Pemlihian Ketua BEM"),
      ),
      body: new Container(
        child: new Center(
          child: new Column(
            children: <Widget>[
              new Text(
                "Username",
                style: new TextStyle(fontSize: 18.0),
              ),
              new TextField(
                controller: usr,
                decoration: new InputDecoration(
                  hintText: "Username",
                ),
              ),
              new Text(
                "Password",
                style:new  TextStyle(fontSize: 18.0),
              ),
              new TextField(
                controller: pass,
                obscureText: true,
                decoration: new InputDecoration(
                  hintText: "Password",
                ),
              ),
              new RaisedButton(
                child: new Text("Login"),
                onPressed: () {
                  _login();
                },
              ),
              new Text(
                msg,
                style: new TextStyle(fontSize: 22.0, color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }
}
