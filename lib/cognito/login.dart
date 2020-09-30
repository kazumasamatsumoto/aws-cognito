import 'package:flutter/material.dart';

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
