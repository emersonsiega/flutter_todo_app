import 'package:flutter/material.dart';
import './screens/home.dart';
import './config/theme_builder.dart';
import 'package:intl/intl.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() {
  Intl.defaultLocale = 'pt_BR';

  initializeDateFormatting('pt_BR').then(
    (_) => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeBuilder.build(context),
      home: Home(),
    );
  }
}
