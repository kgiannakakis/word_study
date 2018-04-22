import 'package:flutter/material.dart';
import 'package:validator/validator.dart';

class WebDownloader extends StatefulWidget {
  WebDownloader();

  @override
  WebDownloaderState createState() => new WebDownloaderState();
}

class WebDownloaderState extends State<WebDownloader> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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
                onFieldSubmitted: (value) {},
                onSaved: (value) {},
              ),
            ),
            const Divider(
              height: 1.0,
            ),
            new Container(
              width: screenSize.width,
              child: new RaisedButton(
                child: new Text('Download'),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
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
