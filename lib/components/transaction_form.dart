import 'package:expenses/components/adaptative_button.dart';
import 'package:expenses/components/adaptative_date_picker.dart';
import 'package:expenses/components/adaptative_text_field.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //permite rolagem no card para contornar o teclado
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            //altura do teclado (se estiver aberto)
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              AdaptativeTextField(
                controller: _titleController,
                label: 'Título',
              ),
              AdaptativeTextField(
                  //opção necessária para o teclado do iOS
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  //_ é uma forma de ignorar o parâmetro que não se deseja usar
                  //teclado iOS não suporta botão DONE no teclado numérico
                  onSubmitted: (_) => _submitForm(),
                  controller: _valueController,
                  label: 'Valor (R\$)'),
              AdaptativeDatePicker(
                selectedDate: _selectedDate,
                onDateChanged: (newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AdaptativeButton(
                    label: 'Nova Transação',
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
