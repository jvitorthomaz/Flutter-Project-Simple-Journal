import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/defaults_dialogs/confirmation_dialog.dart';
import 'package:flutter_webapi_first_course/screens/defaults_dialogs/exception_dialog.dart';

import '../../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService service = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        //padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 35),
        decoration: const BoxDecoration(
          //border: Border.all(width: 2),
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8) , 
            topRight: Radius.circular(8),  
          ),
        ),
           
        child: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(
                      Icons.bookmark,
                      size: 64,
                      color: Colors.brown,
                    ),
                    const Text(
                      "Simple Journal",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(thickness: 2),
                    ),
                    const Text("Entre ou Registre-se"),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        label: Text("E-mail"),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(label: Text("Senha")),
                      keyboardType: TextInputType.visiblePassword,
                      maxLength: 16,
                      obscureText: true,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          login(context);
                        }, child: const Text("Continuar")),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  login(BuildContext context) async{
    String email = _emailController.text;
    String password = _passwordController.text;

    await service.login(email: email, password: password).then(
      (resultLogin) {
        if (resultLogin) {
          Navigator.pushReplacementNamed(context, "home");
        }
      },
    ).catchError(
      (error) {
        var innerError = error as HttpException;
        showExceptionDialog(context, content: innerError.message);
      }, 
      test: (error) => error is HttpException,
    ).catchError((error){
      showConfirmationDialog(
        context,
        title: "Parece que você ainda não esta cadastrado! :( ",
        content: "Deseja criar um novo usuário com o e-mail $email e senha inserida?",
        affirmativeOption: "CRIAR",
      ).then((value) {
        if (value != null && value) {
          service.register(email: email, password: password).then((resultRegister) {
            if (resultRegister) {
              Navigator.pushReplacementNamed(context, "home");
            }
          });
        }
      });
    }, test: (error) => error is UserNotFoundException).catchError(
      (error) {
        showExceptionDialog(context, content: "O servidor não esta respondendo, tente novamente mais tarde!");
      }, test:(error) => error is TimeoutException,
    );    
  }
}
