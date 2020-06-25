import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {

  final String postUrl;
  RecipeView({this.postUrl});

  @override
  _RecipeViewState createState() => _RecipeViewState();

}


class _RecipeViewState extends State<RecipeView> {

  String finalUrl;
  final Completer<WebViewController> _controller=Completer<WebViewController>();


  @override
  void initState() {

    if(widget.postUrl.contains("http://")){
        finalUrl = widget.postUrl.replaceAll("http://", "https://");
    }else{
        finalUrl= widget.postUrl;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        const Color(0xff213A50),
                        const Color(0xff071930)
                      ]
                  )
              ),
              padding: EdgeInsets.only(top: 60,right: 30,left: 30,bottom: 16),
              width: MediaQuery.of(context).size.width,
              child: Row(
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
            ),
            Container(
              height: MediaQuery.of(context).size.height-100,
              width: MediaQuery.of(context).size.width,
              child: WebView(
                initialUrl: finalUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController){
                  setState(() {
                      _controller.complete(webViewController);
                  });
                }),
            ),
          ],
        ),
      ),
    );
  }
}


