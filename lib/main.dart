import 'package:aws_cognito/cognito/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'cognito/login.dart';
import 'cognito/regisuter_user.dart';

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'login sample app',
      routes: <String, WidgetBuilder>{
        '/': (_) => new PickerSample(),
        '/RegisterUser': (_) => new RegisterUserPage(),
        '/ConfirmRegistration': (_) => new ConfirmRegistration(null),
        '/ImagePicker': (_) => new PickerSample(),
      },
    );
  }
}
