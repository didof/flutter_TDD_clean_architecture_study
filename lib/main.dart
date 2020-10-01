import 'package:TDD_clean_architecture/features/number_trivia/presentation/pages/trivia_page.dart';
import 'package:flutter/material.dart';
import 'package:TDD_clean_architecture/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      home: NumberTriviaPage(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
