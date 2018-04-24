import 'package:flutter/material.dart';
import 'package:validator/validator.dart';
import 'package:word_study/models/stored_file.dart';
import 'package:word_study/words/web_wordprovider.dart';
import 'package:word_study/files/file_service.dart';

class WebDownloaderWidget extends StatefulWidget {
  final Function(StoredFile) onAddFile;

  WebDownloaderWidget({this.onAddFile});

  @override
  WebDownloaderState createState() => new WebDownloaderState();
}

class WebDownloaderState extends State<WebDownloaderWidget> {
  final Function(StoredFile) onAddFile;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _fileUrl;
  String _fileName;
  bool _isLoading = false;

  WebDownloaderState({this.onAddFile});

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
                  labelText: "Url",
                  hintText: "Url",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the file url';
                  }
                  if (!isURL(value)) {
                    return 'Please enter a valid url';
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
                  labelText: "Name",
                  hintText: "Name",
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the file name';
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
                child: new Text('Download'),
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
                                  'Can\'t download file'),
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
