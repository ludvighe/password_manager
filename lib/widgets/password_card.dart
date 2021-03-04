import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/providers/master_password.dart';
import 'package:password_manager/providers/password_data_list.dart';
import 'package:password_manager/widgets/dynamic_icon.dart';
import 'package:provider/provider.dart';

class PasswordCard extends StatefulWidget {
  PasswordCard(this.index);

  final int index;

  @override
  _PasswordCardState createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
        height: 80.0,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0,
              offset: Offset(0.0, 3.0),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // DynamicIcon(widget.index),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: DynamicIcon(widget.index),
                      ),
                      Text(
                        Provider.of<PasswordDataList>(context, listen: false)
                            .list[widget.index]
                            .title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Text(
                    'Created: ${Provider.of<PasswordDataList>(context, listen: false).list[widget.index].created.toString().split('.')[0]}',
                    style: TextStyle(
                        // Make text red if 100 days has passed since the creation of the password
                        color: (Provider.of<PasswordDataList>(context, listen: false)
                                    .list[widget.index]
                                    .created
                                    .day <=
                                DateTime.now().day - 100)
                            ? Colors.red
                            : Colors.black),
                  ),
                  Text(
                      'Last used: ${Provider.of<PasswordDataList>(context, listen: false).list[widget.index].lastUsed.toString().split('.')[0]}')
                ],
              ),
              IconButton(
                tooltip: 'Click to copy this password to clipboard',
                icon: Icon(Icons.copy),
                onPressed: () {
                  try {
                    print(widget.index);
                    Clipboard.setData(ClipboardData(
                        text: Encryption.encryptSHA3FromData(
                            Provider.of<MasterPassword>(context, listen: false).masterPassword,
                            Provider.of<PasswordDataList>(context, listen: false)
                                .list[widget.index])));
                    Provider.of<PasswordDataList>(context, listen: false).setLastUsed(
                        Provider.of<PasswordDataList>(context, listen: false).list[widget.index],
                        DateTime.now());
                  } catch (e) {
                    print(e);
                  }
                },
              )
            ],
          ),
        ));
  }
}
