import 'package:flutter/material.dart';

enum AuthMode { signUp, login }

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  var _authMode = AuthMode.login;
  final _passwordController = TextEditingController();

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

    if (_authMode == AuthMode.login) {
      // TODO: lógica de login
    } else {
      // TODO: lógica de registrar
    }

    setState(() {});
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        height: _authMode == AuthMode.login ? 390 : 371,
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
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
                  if (value!.isEmpty || value.length > 8) {
                    return 'Informe uma senha válida';
                  }

                  return null;
                },
                onSaved: (value) => _authData['password'] = value.toString(),
              ),
              Visibility(
                visible: _authMode == AuthMode.signUp,
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
                  onSaved: (value) => _authData['password'] = value.toString(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 8),
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
