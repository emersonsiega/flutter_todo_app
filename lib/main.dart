import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_teste/controller/home_controller.dart';
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
    return MultiProvider(
      providers: [
        Provider<HomeController>(create: (_) => HomeController()),
      ],
      child: MaterialApp(
        title: 'Tasks',
        debugShowCheckedModeBanner: false,
        theme: ThemeBuilder.build(context),
        home: Home(),
      ),
    );
  }
}
