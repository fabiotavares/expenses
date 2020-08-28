import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final void Function(String) onRemove;

  TransactionList(this.transactions, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            // usado tb para obter a altura máxima no contexto do dispositvo
            builder: (ctx, constraints) {
              return Column(
                children: [
                  SizedBox(height: 20), // apenas um espaço
                  Text(
                    'Nenhuma transação cadastrada!',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 20), // apenas um espaço
                  Container(
                    height: constraints.maxHeight * 0.7,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit:
                          BoxFit.cover, //precisa de um pai com tamanho definido
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, idx) {
              final tr = transactions[idx];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                        child: Text('R\$${tr.value}'),
                      ),
                    ),
                  ),
                  title: Text(
                    tr.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                    DateFormat('d MMM y').format(tr.date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 500 // tem mais espaço
                      ? FlatButton.icon( // exibe mais informação
                          onPressed: () => onRemove(tr.id),
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).errorColor,
                          ),
                          label: Text('Excluir'),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () => onRemove(tr.id),
                        ),
                ),
              );
            },
          );
  }
}
