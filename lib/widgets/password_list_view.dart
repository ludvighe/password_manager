import 'package:flutter/material.dart';
import 'package:password_manager/providers/password_data_list.dart';
import 'package:password_manager/screens/password_edit_screen.dart';
import 'package:password_manager/widgets/password_card.dart';
import 'package:provider/provider.dart';

class PasswordListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PasswordDataList>(
        builder: (context, state, child) => ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(color: Theme.of(context).scaffoldBackgroundColor),
              itemBuilder: (BuildContext context, int index) => InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PasswordEditScreen(passwordData: state.list[index])));
                  },
                  child: PasswordCard(index)),
              itemCount: state.list.length,
            ));
  }
}
