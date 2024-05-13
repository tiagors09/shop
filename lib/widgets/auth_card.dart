import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/utils/environment.dart';

enum AuthMode { signUp, login }

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  var _authMode = AuthMode.login;
  final _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _submit() {
    if (!_form.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState!.save();

    final auth = Provider.of<Auth>(context, listen: false);

    Future<void> Function(String, String) authFn;

    if (_authMode == AuthMode.login) {
      authFn = auth.signIn;
    } else {
      authFn = auth.signup;
    }

    authFn(
      _authData['email'].toString(),
      _authData['password'].toString(),
    )
        .then(
      (_) => null,
    )
        .catchError((e) {
      Environment.showErrorMessage(
        context,
        e.toString(),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });

      _animationController.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });

      _animationController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.01,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.linear,
        height: _authMode == AuthMode.login ? 290 : 371,
        padding: const EdgeInsets.all(16),
        width: deviceSize.width * 0.75,
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Informe um e-mail válido';
                  }

                  return null;
                },
                onSaved: (value) => _authData['email'] = value.toString(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                controller: _passwordController,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty || value.length < 8) {
                    return 'Informe uma senha válida';
                  }

                  return null;
                },
                onSaved: (value) => _authData['password'] = value.toString(),
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.signUp ? 60 : 0,
                  maxHeight: _authMode == AuthMode.signUp ? 120 : 0,
                ),
                duration: const Duration(
                  milliseconds: 300,
                ),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Confirmar senha'),
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      validator: _authMode == AuthMode.signUp
                          ? (value) {
                              if (value!.trim().isEmpty ||
                                  value != _passwordController.text) {
                                return 'Senhas são diferentes';
                              }

                              return null;
                            }
                          : null,
                      onSaved: _authMode == AuthMode.signUp
                          ? (value) => _authData['password'] = value.toString()
                          : null,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 3),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 8,
                          ),
                        ),
                        onPressed: _submit,
                        child: Text(
                          _authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
              Visibility(
                visible: !_isLoading,
                child: TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    'ALTERNAR P/ ${_authMode == AuthMode.login ? 'REGISTRAR' : 'LOGIN'}',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
