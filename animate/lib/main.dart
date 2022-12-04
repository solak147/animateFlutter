import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'home/home_page.dart';
import 'splash_page.dart';
import 'simpleBlocDelegate.dart';
import 'firebase/user_repository.dart';
import 'authentication_bloc/bloc.dart';
import 'login/login_page.dart';

void main(){
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        builder: (BuildContext context) => _authenticationBloc,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BlocBuilder(
            bloc: _authenticationBloc,
            builder: (context, state){
              if (state is Authenticated){
                return HomePage();
              }else if (state is Unauthenticated) {
                return LoginPage(userRepository: _userRepository,);
              }
              return SplashPage();
            },
          ),
        )
    );
  }
}

//keytool -exportcert -list -v -alias androiddebugkey -keystore C:/Users/User/.android/debug.keystore
//keytool -exportcert -v -alias androiddebugkey -keystore C:/Users/User/.android/debug.keystore
//keytool  -list -v -alias androiddebugkey -keystore C:/Users/User/.android/debug.keystore
//--no-sound-null-safety