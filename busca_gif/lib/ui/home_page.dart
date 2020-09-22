import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;

  int _offset = 0;

  Future<Map> _getGifs() async{
    http.Response response;//respostas das requisições

  if(_search == null)//se for null receberá url dos melhores gifs
    response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=QaoqGrLVAI9YEU0A2pmanNvbvQFWNnRA&limit=25&rating=G");
  else //se for diferente de null irá realizar uma pesquisa
    response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=QaoqGrLVAI9YEU0A2pmanNvbvQFWNnRA&q=$_search&limit=19&offset=$_offset&rating=G&lang=pt");
  
  return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.black,
      title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
      centerTitle: true,
    ),
    backgroundColor: Colors.black,
    body: Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(10.0),
        child: TextField(
          decoration: InputDecoration(
            labelText: "Pesquise Aqui",
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder()
          ),
          style: TextStyle(color: Colors.white, fontSize: 18.0),
          textAlign: TextAlign.center,
          onSubmitted: (text){
            setState(() {
              _search = text;
              _offset = 0;
            });
          },
        ),),
        Expanded(
          child: FutureBuilder(
            future: _getGifs(),
            builder: (context, snapshot){
              switch (snapshot.connectionState){
                case ConnectionState.waiting:
                  case ConnectionState.none:
                  return Container(
                    width: 200.0,
                    height:200.0,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5.0,
                      ),
                  );
                  default:
                   if(snapshot.hasError) return Container();
                   else return _createGifTable(context, snapshot);
              }
            }
            )
        ),
      ],
    ),
    );
  }

  int _getCount(List data){
    if(_search == null){
      return data.length;
    }else{
      return data.length + 1;
    }
  }
  
  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){//tabela de gifs
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(//como os itens vão ser organizados
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0),
      itemCount: _getCount(snapshot.data["data"]),  
      itemBuilder: (context, index){
        if(_search == null || index < snapshot.data["data"].length)
          return GestureDetector(
            child: Image.network(snapshot.data["data"][index]["images"]["fixed_heigth"]["url"],//caminho de acesso ao json da api
            height: 300.0,
            fit: BoxFit.cover,
            ),
          );
          else
            return Container(
              child:GestureDetector(
                child: Column(children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70.0,),
                  Text("Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),
                ],
                ),
                onTap: (){
                  setState((){
                    _offset += 19;
                  });
                },
              ) ,);
      });
  }
}