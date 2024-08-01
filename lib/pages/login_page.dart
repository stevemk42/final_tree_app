import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_any_logo/flutter_logo.dart';
import 'package:getwidget/getwidget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:final_tree_app/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _isResetting = false;
  bool _redirecting = false;
  bool _validMail = false;
  bool _validEmail = false;
  bool _validPass = false;
  int _stackIndex = 0;
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _mailController = TextEditingController();
  late final TextEditingController _passController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await supabase.auth.signInWithOtp(
        email: _emailController.text.trim(),
        emailRedirectTo:
            kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lien envoyé par mail !')),
        );
        _emailController.clear();
      }
    } on AuthException catch (error) {
      if (mounted) {
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } catch (error) {
      if (mounted) {
        SnackBar(
          content: const Text('Erreur de traîtement (15)'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithEmailAndPass() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await supabase.auth.signInWithPassword(
          email: _mailController.text.trim(),
          password: _passController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connexion réussie !')),
        );
        _mailController.clear();
        _passController.clear();
      }
    } on AuthException catch (error) {
      if (mounted) {
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } catch (error) {
      if (mounted) {
        SnackBar(
          content: const Text('Erreur de traîtement (15)'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resetPass() async {
    // if (_validMail)
    try {
      setState(() {
        _isResetting = true;
      });
      await supabase.auth.resetPasswordForEmail(_mailController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mail de réinitialisation envoyé !')),
        );
        _mailController.clear();
        _passController.clear();
      }
    } on AuthException catch (error) {
      if (mounted) {
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } catch (error) {
      if (mounted) {
        SnackBar(
          content: const Text('Erreur de traîtement (18)'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResetting = false;
        });
      }
    }
  }

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _mailController.dispose();
    _passController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: const Text(
        'Connexion',
        style: TextStyle(fontSize: 20.0),
      )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // https://hpwngmuhfqzeutupnbye.supabase.co/auth/v1/verify?token=pkce_7cc826bda73f7961de9e0921371e5b2a6655710aac3f48fddb0edb8e
          // &type=magiclink
          // &redirect_to=io.supabase.flutterquickstart://login-callback/
          const Image(
            height: 100.0,
            image: AssetImage('assets/logo_b.png'),
          ),
          Container(
            color: Colors.black38,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Column(
              // padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GFButton(
                          onPressed: () {
                            setState(() {
                              _stackIndex = 1;
                            });
                          },
                          text: "Connexion",
                          type: _stackIndex == 1
                              ? GFButtonType.solid
                              : GFButtonType.transparent,
                        ),
                        GFButton(
                          onPressed: () {
                            setState(() {
                              _stackIndex = 0;
                            });
                          },
                          text: "Inscription",
                          type: _stackIndex == 0
                              ? GFButtonType.solid
                              : GFButtonType.transparent,
                        ),
                      ],
                    ),
                    IndexedStack(
                      index: _stackIndex,
                      children: [
                        SizedBox(
                          height: 300.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // const Text(
                              //     'Recevez votre lien de connexion par mail'),
                              // const SizedBox(height: 18),
                              TextFormField(
                                controller: _emailController,
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                              ),
                              // const SizedBox(height: 18),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _signIn,
                                child: Text(_isLoading
                                    ? 'Chargement'
                                    : 'Envoi lien de connexion par mail'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 300.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // const Text('Recevez votre lien de connexion par mail'),
                              // const SizedBox(height: 18),
                              TextFormField(
                                controller: _mailController,
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    errorText: _validMail
                                        ? "Le mail ne peut pas etre vide"
                                        : null),
                              ),
                              TextFormField(
                                controller: _passController,
                                decoration: const InputDecoration(
                                    labelText: 'Mot de passe'),
                              ),
                              //const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : _signInWithEmailAndPass,
                                    child: Text(_isLoading
                                        ? 'Chargement'
                                        : 'Connexion'),
                                  ),
                                  ElevatedButton(
                                    onPressed: _isResetting ? null : _resetPass,
                                    child: Text(_isResetting
                                        ? 'Chargement'
                                        : 'Mot de passe oublié'),
                                  ),
                                ],
                              ),
                              const Text('OU'),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: const Icon(Icons.apple_rounded),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child:
                                        AnyLogo.tech.google.image(height: 20.0),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: const Icon(Icons.facebook_rounded),
                                    // child: AnyLogo.tech.,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
