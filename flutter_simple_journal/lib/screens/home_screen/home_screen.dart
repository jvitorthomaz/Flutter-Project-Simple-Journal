import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/widgets/home_screen_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/logout.dart';
import '../../models/journal_model.dart';
import '../../services/journal_service.dart';
import '../defaults_dialogs/exception_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;
  int? userId;
  String? userToken;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};

  final ScrollController _listScrollController = ScrollController();
  JournalService service = JournalService();

  
  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título basado no dia atual
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
        ),
        actions: [
          IconButton(
            onPressed: (() {
              refresh();
            }), icon: const Icon(Icons.refresh)
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                logout(context);
              }, title: const Text("Sair"), leading: const Icon(Icons.logout),
            )
          ],
        )
      ),
      body: 
      (userId != null && userToken != null) ?
      ListView(
        controller: _listScrollController,
        children: generateListJournalCards(
          windowPage: windowPage,
          currentDay: currentDay,
          database: database,
          refreshFunction: refresh,
          userId: userId!,
          token: userToken!,
        ),
      )
      :
      const Center(child: CircularProgressIndicator(),),

    );
  }

  void refresh() async {
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString("accessToken");
      String? email = prefs.getString("email");
      int? id = prefs.getInt("id");

      if (token != null && id != null && email != null) {
          setState(() {
            userId = id;
            userToken = token;
          });
          service
              .getAll(id: id.toString(), token: token)
              .then((List<Journal> listJournal) {
             setState(() {
            database = {};

            for (Journal journal in listJournal) {
              database[journal.id] = journal;
            }
          });
        });
      } else {
        Navigator.pushReplacementNamed(context, "login");
      }
    },
    ).catchError(
        (error){
          logout(context);
        },
        test: (error) => error is TokenNotValidException,
    ).catchError((error){
        var innerError = error as HttpException;
        showExceptionDialog(context, content: innerError.message);
    }, test: (error) => error is HttpException);
  }

  // void refresh() async {
  //   SharedPreferences.getInstance().then((prefs) {
  //     String? token = prefs.getString("accessToken");
  //     String? email = prefs.getString("email");
  //     int? id = prefs.getInt("id");
  //     print("=>$token\n=>$email\n=>$id");
  //     if (token != null && email != null && id != null) {
  //       setState(() {
  //         userId = id;
  //         userToken = token;
  //       });

  //       service.getAll(id: id.toString(), token: token).then((List<Journal> listJournal) {
  //         setState(() {
  //           database = {};
  //           for (Journal journal in listJournal) {
  //             database[journal.id] = journal;
              
  //           }
  //         });
  //       });
        
  //     } else {
  //       Navigator.pushReplacementNamed(context, "login");
  //     }
  //   });
    
  // }

  // logout(){
  //   SharedPreferences.getInstance().then((prefs) {
  //     prefs.clear();
  //     Navigator.pushReplacementNamed(context, "login");
  //   });
  // }
}
