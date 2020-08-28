import 'package:expenses/components/chart_bar.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  // parâmetro
  final List<Transaction> recentTransaction;

  // constutor
  Chart(this.recentTransaction);

  // get que retorna uma lista das transações dos últimos 7 dias,
  // agrupadas pelo dia da semana...
  List<Map<String, Object>> get groupedTransactions {
    //gera uma lista com 7 elementos, referentes aos últimos sete dias
    return List.generate(7, (index) {
      //obtém o dia anterior...
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      // controle do total gasto neste dia
      double totalSum = 0.0;

      //somando o valor de todas as despesas com a mesma data da iteração
      for (var tr in recentTransaction) {
        bool sameDay = tr.date.day == weekDay.day;
        bool sameMonth = tr.date.month == weekDay.month;
        bool sameYear = tr.date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += tr.value;
        }
      }

      // retornando um map contendo identificação do dia da semana
      // e o total gasto, ou seja, um map com dois elementos
      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    }).reversed.toList(); // inverte a lista
  }

  // get para obter o total gasto na última semana
  double get _weekTotalValue {
    // usando função fold (que é semelhante à função reduce
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + tr['value'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final double weekTotalValue = _weekTotalValue;
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        // necessário pois Row/Card não possuem este atributo
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((tr) {
            return Flexible(
              fit: FlexFit.tight,
              //forçar para ocupar todos os espaços...
              // o que gera espaçamento igual nesse caso, onde todos estão concorrendo
              child: ChartBar(
                label: tr['day'],
                value: tr['value'],
                percentage: weekTotalValue == 0
                    ? 0
                    : (tr['value'] as double) / weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
