import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// cria um botão conforme a plataforma
class AdaptativeButton extends StatelessWidget {
  // parâmetros (que podem aumentar conforme necessário)
  final String label;
  final Function onPressed;

  // construtor com parâmetros nomeados
  AdaptativeButton({
    this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // retornando um botão conforme a plataforma
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(label),
            onPressed: onPressed,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 20),
          )
        : RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).textTheme.button.color,
            child: Text(label),
            onPressed: onPressed,
          );
  }
}
