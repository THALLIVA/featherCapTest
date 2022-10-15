import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:newproject2/characterBio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;
  List films = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<List> filmList(String movieList) async {
    if (movieList.isNotEmpty && movieList.length >= 3) {
      Response response = await Dio().get(
        'https://imdb8.p.rapidapi.com/title/find',
        queryParameters: {"q": movieList},
        options:
            Options(headers: {'X-RapidAPI-Key': '4643b45070msh9dfb21cdf50e273p1b6ed8jsnbdcecc578694', 'X-RapidAPI-Host': 'imdb8.p.rapidapi.com'}),
      );

      print(response.data['results']);
      films = response.data['results'];

      return films;
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) async {
                await filmList(value);
                setState(() {});
              },
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: films.length,
                  itemBuilder: (context, index) {
                    if (films[index]?["title"] != null && films[index]?["image"] != null && films[index]?["principals"] != null) {
                      return Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.network(films[index]?["image"]["url"]),
                            Text(films[index]?["title"] ?? ""),
                            Row(
                              children: List.generate(films[index]?["principals"].length, (index2) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => CharacterBio(id: films[index]?["principals"][index2]["id"])));
                                  },
                                  child: Text(
                                    films[index]?["principals"][index2]["name"] + ", ",
                                    style: const TextStyle(color: Colors.blueAccent),
                                  ),
                                );
                              }),
                            )
                          ],
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
