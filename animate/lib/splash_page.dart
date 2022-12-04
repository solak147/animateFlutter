import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication_bloc/authenticationBloc.dart';
import 'authentication_bloc/authenticationEvent.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    // 從Provider取得bloc
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    //　先前是使用SplashScreen.navigate
    //　現在改用callback，因為可以在onSuccess設定動畫結束後要做的事
    return SplashScreen.callback(
      name: 'assets/splash.flr', // flr動畫檔路徑
      onSuccess: (_){_authenticationBloc.dispatch(AppStarted());}, // 動畫結束後觸發AppStarted事件
      until: () => Future.delayed(Duration(seconds: 3)), //等待3秒
      startAnimation: 'coding', // 動畫名稱
    );
  }

}