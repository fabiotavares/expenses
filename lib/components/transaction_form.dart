import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    //tratamento antes de submeter
    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }

    //forma de acessar o parâmetro passado para o widget (aqui no estado)
    widget.onSubmit(title, value, _selectedDate);
  }

  //método para chamar o calendário
  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019), // 1/1/2019
      lastDate: DateTime.now(), // não aceita data futura
    ).then((pickedDate) {
      // código executado de forma assíncrona, no futuro
      if (pickedDate == null) {
        return;
      }

      setState(() {
        // se uma data foi escolhida, então armazene seu valor
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título',
              ),
            ),
            TextField(
              //opção necessária para o teclado do iOS
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              //_ é uma forma de ignorar o parâmetro que não se deseja usar
              //teclado iOS não suporta botão DONE no teclado numérico
              onSubmitted: (_) => _submitForm(),
              controller: _valueController,
              decoration: InputDecoration(
                labelText: 'Valor (R\$)',
              ),
            ),
            Container(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Nenhuma data selecionada!'
                          : 'Data selecionada: ${DateFormat('dd/MM/y').format(_selectedDate)}',
                    ),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Selecionar Data',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _showDatePicker,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Nova Transação'),
                  textColor: Theme.of(context).textTheme.button.color,
                  onPressed: _submitForm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
