import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/defaults_dialogs/confirmation_dialog.dart';

import '../../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  AuthService service = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        //padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 35),
        decoration: BoxDecoration(
          //border: Border.all(width: 2),
          color: Colors.white,
          borderRadius: const BorderRadius.only(
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
                    const Text("por Alura",
                        style: TextStyle(fontStyle: FontStyle.italic)),
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
    
    try {
      await service.login(email: email, password: password).then((resultLogin) {
        if (resultLogin) {
          Navigator.pushReplacementNamed(context, "home");
        }
      });
    } on UserNotFoundException {
      print("Entrou na exception");
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
    }
    
  }
}