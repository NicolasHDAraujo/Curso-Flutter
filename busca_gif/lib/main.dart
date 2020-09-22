import 'package:flutter/material.dart';

import 'package:busca_gif/ui/home_page.dart';//importando homepage

void main(){
  runApp(MaterialApp(
    home: HomePage(),//tela inicial
    theme: ThemeData(hintColor: Colors.white),
  ));
}

