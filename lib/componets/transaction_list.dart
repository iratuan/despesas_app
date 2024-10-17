import 'package:despesas_app/models/my_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'item_transaction_list.dart';

// Um widget sem estado que representa uma lista de transações
class TransactionList extends StatelessWidget {
  // Lista de transações e função de callback para remover uma transação
  final List<MyTransaction> transactions;
  final void Function(String) onRemove;

  // Construtor que recebe a lista de transações e a função de remoção
  const TransactionList({super.key, required this.transactions, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(  
      margin: EdgeInsets.only(bottom: 30),    
      height: (3.5 * MediaQuery.sizeOf(context).height/5) - 20, // Define a altura do container
      child: transactions.isEmpty
          ? Column(
              children: [
                Text(
                  "Nenhuma transação cadastrada", // Mensagem quando não há transações
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 20, // Espaçamento entre o texto e a imagem
                ),
                Container(
                  height: 200, // Altura da imagem
                  child: Image.asset(
                    'assets/images/waiting.png', // Imagem a ser exibida
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemCount: transactions.length, // Número de itens na lista
              itemBuilder: (ctx, index) {
                final tr = transactions[index]; // Transação atual
                return ItemTransactionList(tr: tr, onRemove: onRemove);
              },
            ),
    );
  }
}


