import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double value;
  final double percentage;

  // construtor com parâmetros nomeados (uso de chaves)
  ChartBar({
    this.label,
    this.value,
    this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container( // necessário para fixar o tamanho do elemento e evitar desalinhamento
          height: 20,
          child: FittedBox( // ajustar o tamanho do texto para caber no espaço
            child: Text('${value.toStringAsFixed(2)}'),
          ),
        ),
        SizedBox(height: 5),
        Container(
          height: 60,
          width: 10,
          child: Stack(
            // desenhando a barra com a sobreposição de dois itens
            alignment: Alignment.bottomCenter, // colorido do gráfico
            children: [
              Container(
                // estrutura da barra (gráfico)
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  color: Color.fromRGBO(220, 220, 220, 1), //frescura
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              // representação da porcentagem
              FractionallySizedBox(
                heightFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}
