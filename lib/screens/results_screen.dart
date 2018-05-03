import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:word_study/localizations.dart';
import 'package:word_study/screens/home_screen.dart';

class ResultsScreen extends StatelessWidget {

  final List<charts.Series<QuizResults, int>> seriesList = [
    new charts.Series<QuizResults, int>(
      id: 'Results',
      domainFn: (QuizResults results, _) => results.category,
      measureFn: (QuizResults results, _) => results.count,
      //colorFn: (QuizResults results, _) => results.category == 1 ?
      //  charts.Color.fromHex(code: '#00C853') : charts.Color.fromHex(code: '#FF1744'),
      data: <QuizResults>[ new QuizResults(0, 10), new QuizResults(1, 20)],
    )
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(WordStudyLocalizations.of(context).results),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (BuildContext context) => new HomeScreen()),
                    (route) => false,
              );
            },
          )
        ]
      ),
      body: new Stack(
        children: <Widget>[
          new charts.PieChart<QuizResults, int>(seriesList,
            animate: true,
            defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60)
          ),
          new Center(child: new Text('23%')),
          new Padding(
              padding: EdgeInsets.all(10.0),
              child: new Align(
                alignment: Alignment.topCenter,
                child: new Text(WordStudyLocalizations.of(context).resultsMessage(10, 30)),
              )
          ),
          //new Text('You got 20 out of 30 correct!')
        ],
      )
    );
  }
}

class QuizResults {
  final int category;
  final int count;

  QuizResults(this.category, this.count);
}