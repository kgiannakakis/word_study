import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:word_study/googledrivedownloader.dart';

class FileDownloader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          bottom: new TabBar(
            tabs: [
              new Tab(icon: new Icon(FontAwesomeIcons.googleDrive)),
              new Tab(icon: new Icon(FontAwesomeIcons.globe)),
            ],
          ),
          title: new Text('File Download'),
        ),
        body: new TabBarView(
          children: [
            new GoogleDriveDownloader(),
            new Icon(FontAwesomeIcons.globe),
          ],
        ),
      ),
    );
  }
}

