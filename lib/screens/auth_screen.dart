import 'package:flutter/material.dart';
import 'package:flutter_shop_application/models/http_exception.dart';
import 'package:flutter_shop_application/providers/auth.dart';
import 'package:flutter_shop_application/providers/user.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthenScreen extends StatelessWidget {
  static const routeName = "/auth-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('assets/images/light-1.png'),
                          )),
                        )),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-2.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      width: 50,
                      height: 50,
                      top: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/clock.png'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin: EdgeInsets.only(top: 50.0),
                        child: Center(
                          child: Text(
                            'Wellcome back',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: AuthCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isVisibility = true;
  bool isVisibility1 = true;
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  bool _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Okay'),
            onPressed: () {
              setState(() {
                _isLoading = false;
              });
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
            _authData['email'].toString(), _authData['password'].toString());
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['email'].toString(), _authData['password'].toString());
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      //color: Colors.grey,
      //height: _authMode == AuthMode.Signup ? 320 : 260,
      constraints:
          BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
      width: deviceSize.width * 0.75,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(143, 148, 251, 0.3),
                      blurRadius: 20.0,
                      offset: Offset(0, 10),
                    )
                  ],
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade100))),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'E-Mail',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.only(left: 10.0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value!;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey.shade100))),
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                isVisibility = !isVisibility;
                              });
                            },
                          ),
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.only(left: 10.0),
                        ),
                        obscureText: isVisibility,
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 5) {
                            return 'Password is too short!';
                          }
                        },
                        onSaved: (value) {
                          _authData['password'] = value!;
                        },
                      ),
                    ),
                    if (_authMode == AuthMode.Signup)
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          enabled: _authMode == AuthMode.Signup,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  isVisibility1 = !isVisibility1;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.only(left: 10.0),
                          ),
                          obscureText: isVisibility1,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match!';
                                  }
                                }
                              : null,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (_isLoading)
                CircularProgressIndicator()
              else
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  width: double.infinity,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0),
                    textColor: Colors.white,
                    color: Color.fromRGBO(143, 148, 251, 1),
                  ),
                ),
              // ignore: deprecated_member_use
              FlatButton(
                child: Text(
                    '${_authMode == AuthMode.Login ? 'Create an new account' : 'I have an account!'}'),
                onPressed: _switchAuthMode,
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textColor: Color.fromRGBO(143, 148, 251, 1),
              ),
              if (_authMode == AuthMode.Login)
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text(
                    'Forgot Password',
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Color.fromRGBO(143, 148, 251, 1),
                )
            ],
          ),
        ),
      ),
    );
  }
}
