import 'dart:convert';
import 'dart:io';
import 'package:foodwisdom/models/recipe_model.dart';
import 'package:foodwisdom/views/receipe_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  List<RecipeModel> recipes =new List<RecipeModel>();
  TextEditingController textEditingController =new TextEditingController();

  /*String applicationId = "cf6717bf";
  String applicationKey = "9fbb6d77749ceac92de9a18c5d4b2820";*/

  getRecipes(String query) async{

    String url="https://api.edamam.com/search?q=$query&app_id=cf6717bf&app_key=9fbb6d77749ceac92de9a18c5d4b2820";

    var response = await http.get(url);
    Map<String,dynamic> jsonData = jsonDecode(response.body);

    jsonData["hits"].forEach((element){
        //print(element.toString());

        RecipeModel recipeModel = new RecipeModel();
        recipeModel=RecipeModel.fromMap(element["recipe"]);
        recipes.add(recipeModel);
    });

    setState(() {});
    print("${recipes.toString()}");
    
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
     body: Stack(
       children: <Widget>[
         Container(
           height: MediaQuery.of(context).size.height,
           width: MediaQuery.of(context).size.width,
           decoration: BoxDecoration(
             gradient: LinearGradient(
               colors: [
                 const Color(0xff213A50),
                 const Color(0xff071930)
               ]
             )
           ),
         ),
         SingleChildScrollView(
           child: Container(
             padding: EdgeInsets.symmetric(vertical: 60,horizontal: 30),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                Row(
                  mainAxisAlignment: kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Wisdom",
                      style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                    ),),
                    Text("Recipes",
                      style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w500
                    ),)
                  ],
                ),
                 SizedBox(height: 30,),
                 Text("What will you cook today?", style: TextStyle(
                   fontSize: 20,
                   color: Colors.white
                 ),),
                 SizedBox(height: 8,),
                 Text("Just Enter Ingredients you have and we will show the best recipe for you!",
                   style: TextStyle(
                     fontSize: 15,
                     color: Colors.white70
                   ),
                 ),
                SizedBox(height: 30,),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                            hintText: "Enter Ingredients",
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.5)
                            )
                          ),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white
                          ),
                        ),
                      ),
                      SizedBox(width: 16,),
                      InkWell(
                        onTap: (){
                          if(textEditingController.text.isNotEmpty){
                            getRecipes(textEditingController.text);
                            print("Just Do It");
                          }else{
                            print("Just Don't do It");
                          }
                        },
                        child: Container(
                          child: Icon(Icons.search,color: Colors.white,),
                        ),
                      )
                    ],
                  ),
                ),
                 Container(
                   child: GridView(
                     shrinkWrap: true,
                     scrollDirection: Axis.vertical,
                     physics: ClampingScrollPhysics(),
                     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                       maxCrossAxisExtent: 200,mainAxisSpacing: 10.0
                     ),
                     children: List.generate(recipes.length, (index) {
                       return GridTile(
                         child: RecipieTile(
                           title: recipes[index].label,
                           desc: recipes[index].source,
                           imgUrl: recipes[index].image,
                           url: recipes[index].url,
                         )
                     );
                     }),
                   ),
                 )
               ],
             ),
           ),
         ),
       ],
     ),
    );
  }
}
class RecipieTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipieTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipieTileState createState() => _RecipieTileState();
}

class _RecipieTileState extends State<RecipieTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecipeView(
                        postUrl: widget.url,
                      )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Overpass'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'OverpassRegular'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
