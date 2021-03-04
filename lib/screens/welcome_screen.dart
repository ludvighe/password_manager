import 'package:flutter/material.dart';
import 'package:password_manager/screens/list_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  TextEditingController _masterPasswordController = TextEditingController();
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.fromLTRB(24.0, 50.0, 24.0, 24.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    height: 120,
                    decoration: BoxDecoration(
                        color: Colors.blue, borderRadius: BorderRadius.circular(12.0)),
                    child: Row(
                      children: [
                        Text(
                          "Murmelpass",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 42.0),
                        ),
                        Expanded(child: Image(image: AssetImage('assets/images/murmel.png')))
                      ],
                    )),
                Padding(padding: EdgeInsets.only(top: 100.0)),
                TextField(
                  controller: _masterPasswordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                      hintText: "Enter password",
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          child: Icon(
                            Icons.visibility,
                            color: (_obscurePassword) ? Colors.grey : Theme.of(context).accentColor,
                          ))),
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListScreen()));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            )));
  }
}
