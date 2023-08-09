import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/models/journal_model.dart';
import 'package:flutter_webapi_first_course/screens/add_journal_screen/add_journal_screen.dart';
import 'package:flutter_webapi_first_course/screens/login_screen/login_screen.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  bool isLogged = await verifyToken();
  runApp(MyApp(isLogged: isLogged));
}

Future<bool> verifyToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("accessToken");
    if (token != null) {
      return true;
    }
    return false;
  }

// json-server --watch --host 192.168.0.3 db.json
// json-server --watch --host 192.168.0.2 db.json
// json-server-auth --watch --host 192.168.1.184 db.json      //192.168.0.6 db.json  192.168.0.2 192.168.1.184
//Feature: update and delete journal

class MyApp extends StatelessWidget {
  final bool? isLogged;

  const MyApp({Key? key, this.isLogged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: GoogleFonts.bitterTextTheme(),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      initialRoute: (isLogged == null) ? 
        "login" 
        : 
        (isLogged!) ? "home" : "login",
      routes: {
        "home": (context) => const HomeScreen(),
        "login": (context) =>  LoginScreen(),
        // "add-journal":(context) => AddJournalScreen(
        //     journal: Journal(
        //       id: "id",
        //       content: "content",
        //       createdAt: DateTime.now(),
        //       updatedAt: DateTime.now()
        //     )
        // ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "add-journal") {
          Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
          final Journal journal = map ["journal"] as Journal;
          final bool isEditing = map["is_editing"];

          return MaterialPageRoute(builder: (context) {
            return AddJournalScreen(
              journal: journal,
              isEditing: isEditing,
            );
          });
        }
        return null;
      },
    );
  }
}
