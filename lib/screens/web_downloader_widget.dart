import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:validator/validator.dart';
import 'package:word_study/models/stored_file.dart';
import 'package:word_study/words/web_wordprovider.dart';
import 'package:word_study/services/file_service.dart';
import 'package:word_study/localizations.dart';

class WebDownloaderWidget extends StatefulWidget {
  @required final Function(StoredFile) onAddFile;

  WebDownloaderWidget({this.onAddFile});

  @override
  WebDownloaderState createState() => new WebDownloaderState(onAddFile: onAddFile);
}

class WebDownloaderState extends State<WebDownloaderWidget> {
  final Function(StoredFile) onAddFile;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _fileUrl;
  String _fileName;
  bool _isLoading = false;

  WebDownloaderState({@required this.onAddFile});

  _download() async {
    var webWordProvider = new WebWordProvider(_fileUrl, null);
    bool ok = await webWordProvider.init();
    if (ok) {
      final FileService fileService = new FileService();
      String filename = await fileService.getNewFilename(_fileName);
      await webWordProvider.store(filename);
    }
    setState(() {
      _isLoading = false;
    });
    return ok;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Builder(builder: (BuildContext context) {
      return new SingleChildScrollView(
        child: new Form(
        key: _formKey,
        child: new Column(
          children: <Widget>[
            new ListTile(
              leading: const Icon(Icons.web),
              title: new TextFormField(
                keyboardType: TextInputType.url,
                initialValue: 'https://',
                decoration: new InputDecoration(
                  labelText: WordStudyLocalizations.of(context).url,
                  hintText: WordStudyLocalizations.of(context).url,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return WordStudyLocalizations.of(context).pleaseEnterTheFileUrl;
                  }
                  if (!isURL(value)) {
                    return WordStudyLocalizations.of(context).pleaseEnterAValidUrl;
                  }
                },
                onFieldSubmitted: (value) => _fileUrl = value,
                onSaved: (value) => _fileUrl = value,
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.web),
              title: new TextFormField(
                keyboardType: TextInputType.text,
                decoration: new InputDecoration(
                  labelText: WordStudyLocalizations.of(context).name,
                  hintText: WordStudyLocalizations.of(context).name,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return WordStudyLocalizations.of(context).pleaseEnterTheNameOfTheFile;
                  }
                },
                onFieldSubmitted: (value) => _fileName = value,
                onSaved: (value) => _fileName = value,
              ),
            ),
            _isLoading ? new LinearProgressIndicator() : const Divider(height: 1.0),
            new Container(
              width: screenSize.width,
              child: new RaisedButton(
                child: new Text(WordStudyLocalizations.of(context).download),
                onPressed: _isLoading ? null : () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    setState(() {
                      _isLoading = true;
                    });
                    bool ok = await _download();
                    if (!ok) {
                      Scaffold.of(context).showSnackBar(
                          new SnackBar(
                              content: new Text(
                                  WordStudyLocalizations.of(context).cantDownloadFile),
                              backgroundColor: Colors.redAccent));
                    }
                    else {
                      onAddFile(new StoredFile(name: _fileName, created: DateTime.now()));
                      Navigator.of(context).pop();
                    }
                  }
                },
              ),
              margin: new EdgeInsets.only(top: 20.0, bottom: 20.0),
            )
          ],
        ),
      ));
    });
  }
}
