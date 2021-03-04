import 'package:flutter/material.dart';
import 'package:password_manager/providers/User.dart';
import 'package:password_manager/providers/master_password.dart';
import 'package:password_manager/providers/password_data_list.dart';
import 'package:password_manager/screens/list_screen.dart';
import 'package:password_manager/utils/api.dart';
import 'package:password_manager/widgets/password_text_field.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  TextEditingController _masterPasswordController = TextEditingController();
  TextEditingController _keyController = TextEditingController();
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
                PasswordTextField(
                  controller: _keyController,
                  hint: 'Enter key',
                ),
                PasswordTextField(
                  controller: _masterPasswordController,
                ),
                RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    Provider.of<MasterPassword>(context, listen: false).masterPassword =
                        _masterPasswordController.text;
                    _masterPasswordController.clear();
                    Provider.of<User>(context, listen: false)
                        .fetchUserDataFromApi(_keyController.text);
                    Provider.of<PasswordDataList>(context, listen: false)
                        .fetchPasswordDataFromApi(Provider.of<User>(context, listen: false).key);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListScreen()));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                RaisedButton(
                    onPressed: () {
                      Api.testApi();
                    },
                    child: Text('General test button'))
              ],
            )));
  }
}
