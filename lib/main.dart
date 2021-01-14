import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as converter;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: JokePage(),
    );
  }
}

class JokePage extends StatefulWidget {
  JokePage({Key key}) : super(key: key);

  @override
  _JokePageState createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  String joke = 'Touch Screen!!';
  Color color = Colors.blueAccent;
  List<Color> colors = [Colors.redAccent, Colors.greenAccent, Colors.greenAccent, Colors.blueAccent, Colors.orangeAccent, Colors.deepOrange, Colors.deepPurple];

  Future<dynamic> getJokes() async{
    var url = 'https://official-joke-api.appspot.com/random_ten';
    // await response from the url 
    var response = await http.get(url);

    if(response.statusCode == 200){
        var jsonData = converter.jsonDecode(response.body);
        return jsonData;
    }
    else return null;
  }

  randomJoke(List jokes){
    var random = new Random();
    int index = random.nextInt(jokes.length ?? 0);
    int colorIndex = random.nextInt(colors.length);
    setState(() {
      color = colors[colorIndex];
      joke = '${jokes[index]['setup']} \n ${jokes[index]['punchline']}';
    });
  }

  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: null,
      body: SafeArea(
        child: FutureBuilder<dynamic>(
          future: getJokes(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done)
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: (snapshot.data != null)?GestureDetector(
                    onTap: ()=> randomJoke(snapshot.data),
                    child: Text(joke ?? '', style: TextStyle(color: Colors.white, fontSize: 50), textAlign: TextAlign.center,)
                  )
                  : Text('No Jokes At This Time',  style: TextStyle(color: Colors.white, fontSize: 50), textAlign:  TextAlign.center,)
                  ),
                );
         

            else if(snapshot.connectionState == ConnectionState.waiting)
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator( )
                ),
              );
            else return 
            Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text('Unable To Connect'),
                ),
              );
          }
          
        ),
        ),

    );
  }
}