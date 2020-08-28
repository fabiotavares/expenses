import 'dart:io';
import 'dart:math';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/components/transaction_list.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

main() {
  runApp(ExpensesApp());
}

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // definindo restrições quanto à orientação do dispositivo
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.portraitUp
//    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      theme: ThemeData(
        //passando um conjunto de cores...
        //que pode ser acessada para pontos específicos assim...
        //Theme.of(context).primaryColor (por exemplo)
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                //antes era title (=headline6)
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  //antes era title (=headline6)
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // controle da exibição do gráfico
  bool _showChart = false;

  // lista de transações
  final List<Transaction> _transactions = [
    Transaction(
      title: 'Despesa #01',
      date: DateTime.now(),
      value: 23.5,
      id: '01',
    ),
    Transaction(
      title: 'Despesa #02',
      date: DateTime.now(),
      value: 23.5,
      id: '02',
    ),
    Transaction(
      title: 'Despesa #03',
      date: DateTime.now(),
      value: 23.5,
      id: '03',
    ),
    Transaction(
      title: 'Despesa #04',
      date: DateTime.now(),
      value: 23.5,
      id: '04',
    ),
    Transaction(
      title: 'Despesa #05',
      date: DateTime.now(),
      value: 23.5,
      id: '05',
    ),
    Transaction(
      title: 'Despesa #06',
      date: DateTime.now(),
      value: 23.5,
      id: '06',
    ),
    Transaction(
      title: 'Despesa #07',
      date: DateTime.now(),
      value: 23.5,
      id: '07',
    ),
    Transaction(
      title: 'Despesa #08',
      date: DateTime.now(),
      value: 23.5,
      id: '08',
    ),
    Transaction(
      title: 'Despesa #09',
      date: DateTime.now(),
      value: 23.5,
      id: '09',
    ),
    Transaction(
      title: 'Despesa #10',
      date: DateTime.now(),
      value: 23.5,
      id: '10',
    ),
  ];

  // gerando uma lista com transações recentes (usando filtro - where)
  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      // entra na lista se a data for posterior à data de 7 dias atrás
      return tr.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  //método para cadastrar uma nova transação
  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    // atualizando a tela com um novo item na lista de transações
    setState(() {
      _transactions.add(newTransaction);
    });

    // aqui é melhor local para fechar o formulário modal,
    // pois é neste contexto que sei de sua existência como modal.
    // a forma de fechar é acessar a tela do topo da pilha assim...
    Navigator.of(context).pop();
  }

  // método para deletar uma transação da lista
  _removeTransaction(String id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  //método para chamar de forma modal o formulário para nova transação
  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  // método para gerar um IconButton conforme a plataforma ios/android
  Widget _getIconButton(IconData icon, Function fn) {
    return Platform.isIOS
        ? GestureDetector(onTap: fn, child: Icon(icon)) // para o iOS
        : IconButton(icon: Icon(icon), onPressed: fn); // para o Android
  }

  @override
  Widget build(BuildContext context) {
    // descobrindo se a orientação do dispositivo é paisagem
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    // definindo os ícones da appBar de acordo com a plataforma
    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final chartList = Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

    // definindo as actions para serem usadas as duas plataformas
    final actions = [
      if (isLandscape) // só exibe a opção se estiver em modo paisagem
        // ação #1 para exibir o gráfico
        _getIconButton(
          _showChart ? iconList : chartList,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      // ação #2 para adicionar nova transação
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add : Icons.add, // icone específico
        () => _openTransactionFormModal(context),
      ),
    ];

    // definindo a appBar para ser usada nas duas plataformas
    // é preciso especifica o tipo aqui pra evitar um erro logo à frente
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Despesas Pessoais'),
            trailing: Row(
              mainAxisSize:
                  MainAxisSize.min, // p/ a linha ocupar o menor espaço
              children: actions,
            ),
          )
        : AppBar(
            centerTitle: false,
            title: Text('Despesas Pessoais'),
            actions: actions,
          );

    // manobras para descobrir a altura realmente disponível para o gráfico e
    // a lista. Pra isso, preciso saber antes, a altura da appBar...
    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SafeArea(
      // necessário para respeitar a área realmente disponível da tela no ios
      child: SingleChildScrollView(
        //precisa que o pai tenha um tamanho predefinido
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showChart ||
                !isLandscape) // forma alternativa ao operador ternário
              Container(
                height: availableHeight * (isLandscape ? 0.8 : 0.3),
                child: Chart(_recentTransactions),
              ),
            if (!_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 1 : 0.7),
                child: TransactionList(_transactions, _removeTransaction),
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS // adaptando os widgets conforme a plataforma atual
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton:
                Platform.isIOS // forma de descobrir a plataforma
                    ? Container()
                    : FloatingActionButton(
                        onPressed: () => _openTransactionFormModal(context),
                        child: Icon(Icons.add),
                      ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
