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

class MyCou extends StatefulWidget {

  const MyCou({super.key});
  
  final String title = 'Cours disponible';

  @override
  State<MyCou> createState() => _MyCouState();
  
}

class _MyCouState extends State<MyCou> {
  final int weekcount = 0;
  Future<List> getData(req) async {
    final response = await http.get(
      //Uri.parse("http://10.0.2.2/2a/tp_centre_equestre/api/getData.php?user_id=$user_id&action=get_cou"),
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
                  const Text('Les cours auxquels je participe', style: TextStyle(color: Colors.green,fontSize: 30)),
                  Card( 
                    child:FutureBuilder<List>(
                      future: getData('user_id=$userid&action=get_weekly_part&week_increment=$weekcount'),
                      builder: (ctx, ss) {
                        if (ss.hasError) {
                          print("Error");
                          print(ss.error);
                        }
                        if (ss.hasData) {
                          print("Has");
                          return Items(list: ss.data as List<dynamic>, text:'m\'absenter', actif: 0 );
                        } else {
                          print("Wait");
                          //print(ss);
                          return const CircularProgressIndicator();
                        }
                      },
                    ),),
                  const Text('Les cours auxquels je m\'absente', style: TextStyle(color: Colors.green,fontSize: 30)),
                  Card(
                  child:FutureBuilder<List>(
                      future: getData('user_id=$userid&action=get_user_NOT_part'),
                      builder: (ctx, ss) {
                        if (ss.hasError) {
                          print("Error");
                          print(ss.error);
                        }
                        if (ss.hasData) {
                          print("Has");
                          return Items(list: ss.data as List<dynamic>, text:'me présenter', actif: 1 );
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
  final String text;
  final int actif;

  const Items({
    super.key, 
    this.list = const ["ERROR::NO LIST PROVIDED"],
    required this.text,
    required this.actif
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
                  child: Text(text),
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog.fullscreen(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Je confirme $text'),
                          const SizedBox(height: 15),
                          TextButton(
                            onPressed: () async{
                              final response = await http.get(
                                  Uri.parse("http://10.0.2.2/2a/tp_centre_equestre/api/setData.php?action=update&id_cour=${list[i]['id_cour']}&id_week=${list[i]['id_week_cour']}&idcav=$userid&actif=$actif"),
                                  headers: {'Content-Type': 'application/json'},
                              );
                              final value = json.decode(response.body);
                              if (value['success'] == true) {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyCou())); 
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
                    ),
                  ),
                ),
              ],
            ));});
  }
}