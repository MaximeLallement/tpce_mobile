/*Packages */
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tpce_mobile/main.dart';
import 'dart:async';
import 'dart:convert';
/* Pages */
import 'globals.dart';
import 'my_cou.dart';
import 'cou.dart';


class MenuPage extends StatefulWidget {

  const MenuPage({super.key, required this.title});

  final String title;
  

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Future<List> getData() async {
  final response = await http.get(
      Uri.parse("http://10.0.2.2/2a/tp_centre_equestre/api/getData.php?user_id=$userid&action=get_cou"),
      headers: {'Content-Type': 'application/json'},
    );
    return json.decode(response.body);
  }
  
  @override
  Widget build(BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.green[200],
            body: Center(
              child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget>[
                        //const Text('Categorie 1'),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              fixedSize: Size.fromWidth(MediaQuery.of(context).size.width*0.8),
                              backgroundColor: Colors.green[400],
                              textStyle: const TextStyle(
                                  fontSize: 20,
                                  color:Colors.green,
                                ),
                            ),
                            onPressed:(){  Navigator.push(context, MaterialPageRoute(builder: (context)=> const Cou()));  },
                            child: const Text('Les Cours', style: TextStyle(color: Colors.white),),
                            
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              fixedSize: Size.fromWidth(MediaQuery.of(context).size.width*0.8),
                              backgroundColor: Colors.green[400],
                              textStyle: const TextStyle(
                                  fontSize: 20,
                                ),
                            ),
                            onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyCou())); },
                            child: const Text('Gérer mes participations', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              fixedSize: Size.fromWidth(MediaQuery.of(context).size.width*0.8),
                              backgroundColor: Colors.green[900],
                              textStyle: const TextStyle(
                                  fontSize: 20,
                                  color:Color.fromARGB(255, 0, 0, 0),
                                ),
                            ),
                            onPressed:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyHomePage(title: "Page de connection",)));  },
                            child: const Text('Me déconnecter', style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ]
                    )
            )

          );
    }
}
