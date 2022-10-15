import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CharacterBio extends StatefulWidget {
  final String id;
  CharacterBio({required this.id});

  @override
  State<CharacterBio> createState() => _CharacterBioState();
}

class _CharacterBioState extends State<CharacterBio> {
  late String characterId;
  Map response2 = {};

  Future<List> bio() async {
    print(widget.id);
    if (widget.id.isNotEmpty && response2 == {}) {
      characterId = getId();
      Response response = await Dio().get(
        'https://imdb8.p.rapidapi.com/actors/get-bio',
        queryParameters: {"nconst": characterId},
        options:
            Options(headers: {'X-RapidAPI-Key': '4643b45070msh9dfb21cdf50e273p1b6ed8jsnbdcecc578694', 'X-RapidAPI-Host': 'imdb8.p.rapidapi.com'}),
      );
      response2 = response.data;
      setState(() {});
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: bio(),
              builder: (context, snapshot) {
                if (response2 != null) {
                  return Column(
                    children: [
                      response2["image"] != null ? Image.network(response2["image"]["url"]) : SizedBox(),
                      response2["legacyNameText"] != null ? Text("Legacy Name: ${response2["legacyNameText"]}") : SizedBox(),
                      response2["birthDate"] != null ? Text("Birth Day: ${response2["birthDate"]}") : SizedBox(),
                      response2["miniBio"] != null ? Text("TextBio: ${response2["miniBios"]["text"]}") : SizedBox(),
                    ],
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  String getId() {
    String bioId = '';
    if (widget.id != '') {
      print("====>2 ${widget.id}");
      List<String>? characters = widget.id.split("/");
      characters.forEach((element) {
        if (element.contains("nm")) {
          bioId = element;
        }
      });
      return bioId;
    }
    return '';
  }
}
