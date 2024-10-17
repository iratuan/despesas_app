import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:math';

import 'componets/chat.dart';
import 'componets/transaction_form.dart';
import 'componets/transaction_list.dart';
import 'models/my_transaction.dart';
import 'services/transaction_db.dart';

// Função principal que inicia o aplicativo Flutter
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(ExpensesApp());
  });
}

// Classe principal do aplicativo que é um StatelessWidget
class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define o tema padrão do aplicativo
    final ThemeData tema = ThemeData();

    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
      home: MyHomePage(), // Define a página inicial do aplicativo
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple, // Cor primária do tema
          secondary: Colors.amber, // Cor secundária do tema
        ),
        textTheme: tema.textTheme.copyWith(
          headlineMedium: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headlineSmall: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Theme.of(context).colorScheme.primary, // Cor da AppBar
          titleTextStyle: const TextStyle(
            fontFamily: 'QuickSand',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')], // Localização para português do Brasil
    );
  }
}

// Página inicial do aplicativo que é um StatefulWidget
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Estado associado ao MyHomePage
class _MyHomePageState extends State<MyHomePage> {
  List<MyTransaction> _transactions = []; // Lista de transações
  List<MyTransaction> _filteredTransactions = []; // Lista de transações filtradas
  String _searchQuery = ''; // Consulta de busca

  @override
  void initState() {
    super.initState();
    _loadTransactions(); // Carrega as transações ao iniciar
  }

  // Carrega as transações do banco de dados
  Future<void> _loadTransactions() async {
    final data = await TransactionDataBase.instance.getTransactions();
    setState(() {
      _transactions = data;
      _filteredTransactions = data; // Inicialmente sem filtro
    });
  }

  // Adiciona uma nova transação
  void _addTransaction(String title, double value, DateTime date) async {
    final newTransaction = MyTransaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    await TransactionDataBase.instance.insertTransaction(newTransaction);
    _loadTransactions(); // Atualiza a UI
    Navigator.of(context).pop(); // Fecha o modal
  }

  // Remove uma transação pelo ID
  void _removeTransaction(String id) async {
    await TransactionDataBase.instance.removeTransaction(id);
    _loadTransactions(); // Atualiza a UI
  }

  // Abre o formulário de transação em um modal
  void _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(onSubmit: _addTransaction);
        });
  }

  // Filtra a lista de transações com base na busca
  void _filterTransactions(String query) {
    final filtered = _transactions.where((transaction) {
      final titleLower = transaction.title.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower); // Filtra pelo título
    }).toList();

    setState(() {
      _searchQuery = query;
      _filteredTransactions = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            _filterTransactions(value); // Atualiza a busca
          },
          decoration: const InputDecoration(
            hintText: 'Buscar transações...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
            icon: Icon(Icons.search, color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () => _openTransactionFormModal(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Chart(_filteredTransactions), // Usa a lista filtrada
            TransactionList(
              transactions: _filteredTransactions, // Usa a lista filtrada
              onRemove: _removeTransaction,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () => _openTransactionFormModal(context),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
