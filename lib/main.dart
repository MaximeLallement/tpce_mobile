/*Packages */
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tpce_mobile/dashboard.dart';
import 'dart:convert';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
/* Pages */
import 'globals.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Centre Equestre',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Centre Equestre'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  //main();
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[200],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.grass,size: 100,),
              Container(
                padding: const EdgeInsets.all(10),
                child:  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Identifiant / email',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mot de passe',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: FloatingActionButton(
                  onPressed:
                  () async{
                    final username = usernameController.text;
                    final password = passwordController.text;
                    final response = await http.get(
                        Uri.parse("http://10.0.2.2/2a/tp_centre_equestre/api/getData.php?username=$username&password=$password"),
                        headers: {'Content-Type': 'application/json'},
                    );
                    print(json.decode(response.body));
                    final value = json.decode(response.body);
                    if (value['success'] == true) {
                      userid = int.parse(value['user']['id_personne']);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const MenuPage(title: 'Menu Principal')));
                    }

                  },
                  backgroundColor: Colors.amber,
                  child: const Icon(Icons.arrow_forward_ios_rounded),
                ),
              )
            ],
        )));
  }
}

