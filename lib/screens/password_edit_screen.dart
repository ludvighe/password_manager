import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_manager/providers/User.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/providers/password_data.dart';
import 'package:password_manager/providers/password_data_list.dart';
import 'package:password_manager/utils/info_dialog.dart';
import 'package:provider/provider.dart';

class PasswordEditScreen extends StatefulWidget {
  final PasswordData passwordData;

  PasswordEditScreen({this.passwordData});

  @override
  _PasswordEditScreenState createState() => _PasswordEditScreenState();
}

class _PasswordEditScreenState extends State<PasswordEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController = TextEditingController()..text;
  final TextEditingController _saltController = TextEditingController();
  final TextEditingController _countController = TextEditingController();

  String _submitString = 'Submit';
  bool _showAdvanced = false;

  bool _autoSalt = true;
  bool _defaultCount = true;
  HashLength _length = HashLength.HL32;

  @override
  void initState() {
    super.initState();
    if (widget.passwordData == null) {
      _submitString = 'Create';
    } else {
      _submitString = 'Update';
      _titleController.text = widget.passwordData.title;
      _urlController.text = widget.passwordData.url;
      _autoSalt = false;
      _saltController.text = widget.passwordData.salt;
      _defaultCount = false;
      _countController.text = widget.passwordData.count.toString();
      _length = widget.passwordData.length;
    }
  }

  double _sliderValue() {
    switch (_length) {
      case HashLength.HL16:
        return 0.0;
        break;
      case HashLength.HL32:
        return 1.0;
        break;
      case HashLength.HL64:
        return 2.0;
        break;
      case HashLength.HL128:
        return 3.0;
        break;
      case HashLength.HL256:
        return 4.0;
        break;
      default:
        return 0.0;
        break;
    }
  }

  void _onSubmit() async {
    PasswordDataList provider = Provider.of<PasswordDataList>(context, listen: false);
    if (widget.passwordData == null) {
      provider
          .add(Provider.of<User>(context, listen: false).key,
              title: _titleController.text,
              url: _urlController.text,
              salt: (_autoSalt) ? Encryption.defaultSaltGen() : _saltController.text,
              count: (_defaultCount) ? Encryption.DEFAULT_COUNT : int.parse(_countController.text),
              length: _length)
          .then((success) {
        if (!success) networkFailureDialog(context, 'add');
      });
    } else {
      if (!await _yesNoDialog('Update', 'update')) return;
      provider
          .update(
              Provider.of<User>(context, listen: false).key,
              widget.passwordData,
              _titleController.text,
              _urlController.text,
              (_autoSalt) ? Encryption.defaultSaltGen() : _saltController.text,
              (_defaultCount) ? Encryption.DEFAULT_COUNT : int.parse(_countController.text),
              _length)
          .then((success) {
        if (!success) networkFailureDialog(context, 'update');
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.arrow_back),
                            Text('Discard changes'),
                          ],
                        ),
                      ),
                    ),
                    if (widget.passwordData != null)
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).errorColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (!await _yesNoDialog("Delete", "delete")) return;
                            Provider.of<PasswordDataList>(context, listen: false)
                                .remove(Provider.of<User>(context, listen: false).key,
                                    widget.passwordData)
                                .then((success) => networkFailureDialog(context, 'remove'));
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [Text('Delete password'), Icon(Icons.close)],
                          ),
                        ),
                      )
                  ],
                ),
                _titleInputField(),
                _urlInputField(),
                // _lengthInputField(),
                _lengthSlider(),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _showAdvanced = !_showAdvanced;
                      });
                    },
                    child: Row(
                      children: [
                        Text('Advanced'),
                        Icon((_showAdvanced) ? Icons.expand_less : Icons.expand_more)
                      ],
                    )),
                if (_showAdvanced) _genericContainer(_saltInputField()),
                if (_showAdvanced) _genericContainer(_countInputField()),
                FlatButton(
                  onPressed: _onSubmit,
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text(_submitString),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _genericContainer(Widget child) {
    return SizedBox(
      height: 200.0,
      child: Container(
        margin: EdgeInsets.only(bottom: 24.0),
        child: Ink(
            decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 3.0, offset: Offset(0.0, 5.0))
                ]),
            padding: EdgeInsets.all(5.0),
            child: child),
      ),
    );
  }

  Widget _titleInputField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(labelText: 'Title'),
    );
  }

  Widget _urlInputField() {
    return TextFormField(
      controller: _urlController,
      decoration: InputDecoration(labelText: 'URL'),
    );
  }

  Widget _lengthSlider() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Length of password', style: Theme.of(context).textTheme.caption),
          Row(
            children: [
              Text('${(16 * pow(2, _sliderValue())).toInt()}'),
              Expanded(
                child: Slider(
                    label: '${(16 * pow(2, _sliderValue())).toInt()}',
                    value: _sliderValue(),
                    min: 0.0,
                    max: 4.0,
                    divisions: 4,
                    onChanged: (value) {
                      setState(() {
                        switch (value.toInt()) {
                          case 0:
                            _length = HashLength.HL16;
                            break;
                          case 1:
                            _length = HashLength.HL32;
                            break;
                          case 2:
                            _length = HashLength.HL64;
                            break;
                          case 3:
                            _length = HashLength.HL128;
                            break;
                          case 4:
                            _length = HashLength.HL256;
                        }
                      });
                    }),
              ),
            ],
          ),
          Divider(
            color: Colors.black,
            thickness: 0.5,
          )
        ],
      ),
    );
  }

  Widget _saltInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Salt', style: Theme.of(context).textTheme.subtitle1),
            IconButton(
                icon: Icon(Icons.info),
                onPressed: () => infoDialog(context, 'Salt',
                    'A salt is appended to your password before the hashing phase making it unique. It is highly recommended to use a random string of characters.'))
          ],
        ),
        Row(
          children: [
            Checkbox(
                value: _autoSalt,
                onChanged: (value) {
                  setState(() {
                    (value)
                        ? _saltController.clear()
                        : _saltController.text = widget.passwordData.salt;
                    _autoSalt = value;
                  });
                }),
            Text('Use randomly generated salt (recommended)')
          ],
        ),
        TextFormField(
          controller: _saltController,
          enabled: !_autoSalt,
          decoration: InputDecoration(labelText: 'Salt'),
        ),
      ],
    );
  }

  Widget _countInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Iteration count',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            IconButton(
                icon: Icon(Icons.info),
                onPressed: () => infoDialog(context, 'Iteration count',
                    'This decides how many times the password will be run through the hashing function.\n\nNote: Excessive number of iterations can take some time to finish.'))
          ],
        ),
        Row(
          children: [
            Checkbox(
                value: _defaultCount,
                onChanged: (value) {
                  setState(() {
                    (value)
                        ? _countController.clear()
                        : _countController.text = widget.passwordData.count.toString();
                    _defaultCount = value;
                  });
                }),
            Text('Use default iteration count (${Encryption.DEFAULT_COUNT})')
          ],
        ),
        Expanded(
          child: TextFormField(
            controller: _countController,
            enabled: !_defaultCount,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(labelText: 'Iterations'),
          ),
        ),
      ],
    );
  }

  Future<bool> _yesNoDialog(String title, String action) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(title),
              content: Text('Are you sure you want to $action this password?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: Text('No')),
                TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Yes'))
              ],
            ));
  }
}
