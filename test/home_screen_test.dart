import 'package:flutter_test/flutter_test.dart';
import 'package:redux/redux.dart';
import 'package:word_study/main.dart';
import 'package:word_study/middleware/middleware.dart';
import 'package:word_study/models/app_state.dart';
import 'package:word_study/reducers/app_state_reducer.dart';

void main() {
  testWidgets('Home screen starts in loading mode', (WidgetTester tester) async {
    var store = new Store<AppState>(
        appReducer,
        initialState: new AppState.loading(),
        middleware: createMiddleware()
    );

    await tester.pumpWidget(new WordStudyApp(store));
  });
}