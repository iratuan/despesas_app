import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/my_transaction.dart';

class ItemTransactionList extends StatelessWidget {
  const ItemTransactionList({
    super.key,
    required this.tr,
    required this.onRemove,
  });

  final MyTransaction tr;
  final void Function(String p1) onRemove;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(tr.id), // Chave única para cada item
      direction: DismissDirection.endToStart, // Direção do arrasto
      onDismissed: (direction) {
        onRemove(tr.id); // Remove a transação ao arrastar
      },
      background: Container(
        color: Theme.of(context).colorScheme.error, // Cor de fundo ao arrastar
        alignment: Alignment.centerRight, // Alinha o ícone à direita
        padding: const EdgeInsets.only(right: 20), // Espaçamento à direita
        child: const Icon(
          Icons.delete, // Ícone de deletar
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), // Margens do cartão
        elevation: 1, // Elevação do cartão
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary, // Cor de fundo do avatar
            radius: 30, // Raio do avatar
            child: Padding(
              padding: const EdgeInsets.all(6.0), // Espaçamento interno do avatar
              child: FittedBox(
                child: Text(
                  'R\$${tr.value}', // Valor da transação
                  style: const TextStyle(color: Colors.white), // Cor do texto
                ),
              ),
            ),
          ),
          title: Text(
            tr.title, // Título da transação
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          subtitle: Text(
            DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br').format(tr.date), // Data da transação
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete), // Ícone de deletar
            color: Theme.of(context).colorScheme.error, // Cor do ícone
            onPressed: () => onRemove(tr.id), // Remove a transação ao clicar
          ),
        ),
      ),
    );
  }
}