import 'package:flutter/material.dart';
import '../firebase/user_repository.dart';
import 'bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  final UserRepository _userRepository;

  LoginPage({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (BuildContext context) => LoginBloc(userRepository: _userRepository),
      child: LoginForm(userRepository: _userRepository),
    );
  }
}