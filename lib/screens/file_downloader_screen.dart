import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/screens/google_drive_downloader_widget.dart';
import 'package:word_study/screens/web_downloader_widget.dart';
import 'package:word_study/localizations.dart';
import 'package:word_study/screens/file_downloader_view_model.dart';

class FileDownloaderScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, FileDownloaderViewModel>(
      converter: (Store<AppState> store) {
        return FileDownloaderViewModel.fromStore(store);
      },
      builder: (BuildContext context, FileDownloaderViewModel vm) {
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
              title: new Text(WordStudyLocalizations.of(context).fileDownload),
            ),
            body: new TabBarView(
              children: [
                new GoogleDriveDownloader(onAddFile: vm.onAddFile),
                new WebDownloaderWidget(onAddFile: vm.onAddFile),
              ],
            ),
          ),
        );
      }
    );
  }
}


