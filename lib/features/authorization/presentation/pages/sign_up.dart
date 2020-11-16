import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pr;
import 'package:tasks_app/core/constants.dart';
import 'package:tasks_app/core/widgets/loading_widget.dart';
import 'package:tasks_app/features/authorization/domain/services/auth_service.dart';

class SignUp extends StatefulWidget {

  final Function toggleView;
  SignUp({ this.toggleView });

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {

    final authServiceProvider = pr.Provider.of<AuthService>(context);

    return loading ? LoadingWidget() : Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Register',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontSize: 19.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              TextFormField(
                  focusNode: _emailFocus,
                  decoration: textInputDecoration.copyWith(hintText: 'E-mail'),
                  keyboardType: TextInputType.text,
                  validator: (val) => val.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                  initialValue: email != null ? email : "",
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term){
                    _fieldFocusChange(context, _emailFocus, _passwordFocus);
                  }
              ),
              SizedBox(height: 20.0),
              TextFormField(
                  focusNode: _passwordFocus,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val) => val.length < 3 ? 'Enter a password 3+ chars long' : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                  initialValue: password != null ? password : "",
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (term){
                    _passwordFocus.unfocus();
                    _signUp(authServiceProvider);
                  }
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Login / Register',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Switch(
                      value: false,
                      activeColor: Colors.green,
                      onChanged: (bool value)
                      {
                        widget.toggleView();
                      }
                  )
                ],
              ),
              SizedBox(height: 10.0),
              SizedBox(
                  width: double.infinity, // match_parent
                  child: RaisedButton(
                      color: Colors.grey[600],
                      padding: EdgeInsets.only(left: 50, top: 15, right: 50, bottom: 15),
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                      onPressed: () async {
                        _signUp(authServiceProvider);
                      }
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// Change fields focus nod
  ///
  _fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  ///
  /// Launch log in process
  ///
  Future<void> _signUp(AuthService authServiceProvider) async
  {
    if(_formKey.currentState.validate()) {

      setState(() => loading = true);

      dynamic result = await authServiceProvider.addNewUser(email, password);

      if(result != null) {

        setState(() {
          loading = false;
        });

        Flushbar(
          message: result,
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          duration: Duration(seconds: 5),
          leftBarIndicatorColor: Colors.blue[300],
        )..show(context);
      }
    }
  }
}