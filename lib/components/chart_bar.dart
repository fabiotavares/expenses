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
    return LayoutBuilder( // usado para expandir as barras (deu certo com Expand tb)
      // a vantagem aqui é poder escalar todas as dimensões em termos do que tem
      // disponível, removendo os valores fixos e permitindo uma maior responsividade
      builder: (ctx, constraints) {
        return Column(
          children: [
            Container(
              // necessário para fixar o tamanho do elemento e evitar desalinhamento
              height: constraints.maxHeight * 0.15,
              // ajustar o tamanho do texto para caber no espaço
              child: FittedBox(child: Text('${value.toStringAsFixed(2)}')),
            ),
            SizedBox(height: constraints.maxHeight * 0.05),
            Container(
              // também funciona colocando Expanded
              height: constraints.maxHeight * 0.6,
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
            SizedBox(height: constraints.maxHeight * 0.05),
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(child: Text(label)),
            ),
          ],
        );
      },
    );
  }
}
