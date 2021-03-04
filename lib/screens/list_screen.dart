import 'package:flutter/material.dart';
import 'package:password_manager/providers/master_password.dart';
import 'package:password_manager/providers/password_data_list.dart';
import 'package:password_manager/screens/password_edit_screen.dart';
import 'package:password_manager/widgets/password_list_view.dart';
import 'package:password_manager/widgets/password_text_field.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your passwords'),
        actions: [
          IconButton(
              tooltip: 'Enter another password',
              icon: Icon(Icons.lock),
              onPressed: () {
                _displayPasswordDialog();
              }),
          PopupMenuButton(
            tooltip: 'Click to sort passwords by...',
            icon: Icon(Icons.sort),
            onSelected: (int result) {
              Provider.of<PasswordDataList>(context, listen: false).sort(result);
            },
            itemBuilder: (context) => <PopupMenuEntry<int>>[
              PopupMenuItem(
                  value: PasswordDataList.SORT_BY_TITLE,
                  child: Row(children: [
                    Icon(
                      Icons.sort_by_alpha,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    Text(': Title'),
                  ])),
              PopupMenuItem(
                  value: PasswordDataList.SORT_BY_CREATED,
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      Text(': Created'),
                    ],
                  )),
              PopupMenuItem(
                  value: PasswordDataList.SORT_BY_LAST_USED,
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      Text(': Last used'),
                    ],
                  ))
            ],
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 24.0, right: 24.0),
        child: PasswordListView(),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Click to enter password',
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordEditScreen()));
          }),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  Future<String> _displayPasswordDialog() async {
    TextEditingController _masterPasswordController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Enter password'),
              content: PasswordTextField(controller: _masterPasswordController),
              actions: [
                RaisedButton(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close),
                ),
                RaisedButton(
                  padding: EdgeInsets.only(left: 100.0, right: 100.0),
                  color: Colors.green,
                  onPressed: () {
                    Provider.of<MasterPassword>(context, listen: false).masterPassword =
                        _masterPasswordController.text;
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.check),
                )
              ],
            );
          });
        });
  }
}
