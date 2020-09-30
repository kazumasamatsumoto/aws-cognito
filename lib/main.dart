import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final userPool =
    new CognitoUserPool(DotEnv().env['POOL_ID'], DotEnv().env['APP_CLIENT_ID']);

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
        '/': (_) => new MyHomePage(),
        '/RegisterUser': (_) => new RegisterUserPage(),
        '/ConfirmRegistration': (_) => new ConfirmRegistration(null),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('新しいアカウントの作成'),
              color: Colors.indigo,
              textColor: Colors.white,
              shape: StadiumBorder(),
              onPressed: () => Navigator.of(context).pushNamed('/RegisterUser'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterUserPage extends StatelessWidget {
  final _mailAddressController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アカウント作成'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'test@examle.com',
                    labelText: 'メールアドレス',
                  ),
                  controller: _mailAddressController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'password',
                    labelText: 'パスワード',
                  ),
                  obscureText: true,
                  controller: _passwordController,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text('登録'),
                  color: Colors.indigo,
                  shape: StadiumBorder(),
                  textColor: Colors.white,
                  onPressed: () => _signUp(context),
                ),
              ),
            ]),
      ),
    );
  }

  void _signUp(BuildContext context) async {
    try {
      CognitoUserPoolData userPoolData = await userPool.signUp(
          _mailAddressController.text, _passwordController.text);
      Navigator.push(
        context,
        new MaterialPageRoute<Null>(
          settings: const RouteSettings(name: "/ConfirmRegistration"),
          builder: (BuildContext context) => ConfirmRegistration(userPoolData),
        ),
      );
    } on CognitoClientException catch (e) {
      await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text(e.message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(1),
              ),
            ],
          );
        },
      );
    }
  }
}

class ConfirmRegistration extends StatelessWidget {
  final _registrationController = TextEditingController();
  final CognitoUserPoolData _userPoolData;

  ConfirmRegistration(this._userPoolData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('レジストレーションキー確認'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_userPoolData.user.username),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'レジストレーションコード',
                    labelText: 'レジストレーションコード',
                  ),
                  obscureText: true,
                  controller: _registrationController,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 8.0),
                child: RaisedButton(
                  child: Text('確認'),
                  color: Colors.indigo,
                  shape: StadiumBorder(),
                  textColor: Colors.white,
                  onPressed: () => _confirmRegistration(context),
                ),
              ),
            ]),
      ),
    );
  }

  void _confirmRegistration(BuildContext context) async {
    try {
      await _userPoolData.user
          .confirmRegistration(_registrationController.text);
      await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('登録完了'),
            content: Text('ユーザーの登録が完了しました。'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () =>
                    Navigator.of(context).popUntil(ModalRoute.withName('/')),
              ),
            ],
          );
        },
      );
    } on CognitoClientException catch (e) {
      await showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text(e.message),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(1),
              ),
            ],
          );
        },
      );
    }
  }
}
