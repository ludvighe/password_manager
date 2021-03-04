import 'package:flutter/material.dart';
import 'package:password_manager/providers/password_data_list.dart';
import 'package:provider/provider.dart';

class DynamicIcon extends StatefulWidget {
  final int index;
  DynamicIcon(this.index);
  @override
  _DynamicIconState createState() => _DynamicIconState();
}

class _DynamicIconState extends State<DynamicIcon> {
  List<String> _locallySupportedIcons = [
    'amazon',
    'facebook',
    'github',
    'google',
    'instagram',
    'linkedin',
    'myspace',
    'pinterest',
    'reddit',
    'stackoverflow',
    'tiktok',
    'tumblr',
    'twitter',
    'whatsapp',
    'yelp',
    'youtube'
  ];

  List<String> _supportedFavicons = [
    'https://github.com',
  ];

  Widget _icon() {
    var provider = Provider.of<PasswordDataList>(context, listen: false).list[widget.index];
    Widget icon = _localImage(provider);
    if (icon == null) {
      return Icon(Icons.lock);
    } else {
      return icon;
    }
  }

  Image _localImage(provider) {
    for (String i in _locallySupportedIcons) {
      if (Provider.of<PasswordDataList>(context, listen: false)
          .list[widget.index]
          .title
          .toLowerCase()
          .contains(i)) {
        return Image(
          image: AssetImage('assets/icons/$i.png'),
          height: 25,
        );
      }
    }
    return null;
  }

  Image _networkImage(provider) {
    return Image.network(
      '${provider.url}/favicon.ico',
    );
  }

  @override
  Widget build(BuildContext context) {
    return _icon();
  }
}
