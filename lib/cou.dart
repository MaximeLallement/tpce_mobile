/*Packages */
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
/* Pages */
import 'package:tpce_mobile/main.dart';
import 'globals.dart';
import 'dashboard.dart';

class Cou extends StatefulWidget {

  const Cou({super.key});
  
  final String title = 'Mes Cours';

  @override
  State<Cou> createState() => _CouState();
  
}

class _CouState extends State<Cou> {
  Future<List> getData(req) async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2/2a/tp_centre_equestre/api/getData.php?$req"),
      headers: {'Content-Type': 'application/json'},
    );
    return json.decode(response.body);
  }
  @override
  Widget build(BuildContext context) {
          return Scaffold(
            body:Center(
              child: ListView(
                children: [
                  const Text('Les cours du centre', style: TextStyle(color: Colors.green,fontSize: 30)),
                  Card( 
                    child:FutureBuilder<List>(
                      future: getData('user_id=$userid&action=get_cou'),
                      builder: (ctx, ss) {
                        if (ss.hasError) {
                          print("Error");
                          print(ss.error);
                        }
                        if (ss.hasData) {
                          print("Has");
                          return Items(list: ss.data as List<dynamic> );
                        } else {
                          print("Wait");
                          //print(ss);
                          return const CircularProgressIndicator();
                        }
                      },
                    ),),
              ]),),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.blue,),label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.logout, color: Colors.blue,),label: "Disconnect"),
                ],
                onTap: (value) {
                  if (value == 0) Navigator.push(context, MaterialPageRoute(builder: (context)=> const MenuPage(title: "Dashboard")));
                  if (value == 1) Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyHomePage(title: "Page de Connexion"))); 
                },
            )
        );
              
          
    }
}

class Items extends StatelessWidget {

  final List list;

  const Items({
    super.key, 
    this.list = const ["ERROR::NO LIST PROVIDED"],
    });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: list.length,
        itemBuilder: (ctx, i) {
          return Card(
            child:Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.access_alarms),
                  title: Text(list[i]["title"]),
                  subtitle: Text(
                    DateFormat('dd/MM').format( DateTime.parse( list[i]["start_event"]) )
                    +"   "
                    +DateFormat('HH:mm').format( DateTime.parse( list[i]["start_event"]) )
                    +" - "
                    +DateFormat('HH:mm').format(DateTime.parse( list[i]["end_event"]))
                  ),
                ),
                TextButton(
                  child: const Text('Je participe'),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog.fullscreen(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Je veux m\'inscrire à ce cours'),
                          const SizedBox(height: 15),
                           TextButton(
                            onPressed: () async{
                              print(Uri.parse("http://10.0.2.2/2a/tp_centre_equestre/api/setData.php?action=add&id_cour=${list[i]['id_cours']}&idcav=$userid"));
                              final response = await http.get(
                                  Uri.parse("http://10.0.2.2/2a/tp_centre_equestre/api/setData.php?action=add&id_cour=${list[i]['id_cours']}&idcav=$userid"),
                                  headers: {'Content-Type': 'application/json'},
                              );
                              final value = json.decode(response.body);
                              print(value);
                              if (value['success'] == true) {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> const Cou()));
                              }
                            },
                            child: const Text('Oui'),
                          ),
                          TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Text('Non'),
                          ),
                        ],
                      ),
                    ),),),
              ],));

        });
  }
}