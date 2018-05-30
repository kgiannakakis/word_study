import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:word_study/localizations.dart';
import 'package:word_study/screens/home_screen.dart';

class ResultsScreen extends StatelessWidget {

  final int wordsCount;

  final int correctCount;

  ResultsScreen(this.wordsCount, this.correctCount);

  @override
  Widget build(BuildContext context) {

    print('$correctCount $wordsCount');

    List<charts.Series<_QuizResults, int>> seriesList = [
      new charts.Series<_QuizResults, int>(
        id: 'Results',
        domainFn: (_QuizResults results, _) => results.category,
        measureFn: (_QuizResults results, _) => results.count,
        colorFn: (_QuizResults results, _) => results.category == 1 ?
          charts.Color.fromHex(code: '#FF1744') : charts.Color.fromHex(code: '#00C853'),
        data: <_QuizResults>[
          new _QuizResults(0, 1.0*correctCount + 0.000001),
          new _QuizResults(1, wordsCount - correctCount + 0.00001)],
      )
    ];

    String percent = (100.0*correctCount/wordsCount).toStringAsFixed(1);

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
          new charts.PieChart(seriesList,
            //animate: true,
            defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60)
          ),
          new Center(child: new Text('$percent%')),
          new Padding(
              padding: EdgeInsets.all(10.0),
              child: new Align(
                alignment: Alignment.topCenter,
                child: new Text(WordStudyLocalizations.of(context).resultsMessage(correctCount, wordsCount)),
              )
          ),
        ],
      )
    );
  }
}

class _QuizResults {
  final int category;
  final double count;

  _QuizResults(this.category, this.count);
}