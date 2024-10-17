import 'package:despesas_app/componets/chart_bar.dart';
import 'package:flutter/material.dart';
import '../models/my_transaction.dart';
import 'package:intl/intl.dart';

// Um widget sem estado que representa um gráfico de barras para transações recentes
class Chart extends StatelessWidget {
  // Lista de transações recentes
  final List<MyTransaction> recentTransactions;

  // Construtor que recebe a lista de transações recentes
  Chart(this.recentTransactions);

  // Getter que agrupa as transações por dia da semana
  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      // Calcula o dia da semana atual, subtraindo o índice de dias
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0; // Soma total das transações para o dia

      // Itera sobre as transações recentes para calcular a soma total do dia
      for (var i = 0; i < recentTransactions.length; i++) {
        bool sameDay = recentTransactions[i].date.day == weekDay.day;
        bool sameMonth = recentTransactions[i].date.month == weekDay.month;
        bool sameYear = recentTransactions[i].date.year == weekDay.year;

        // Se a transação ocorreu no mesmo dia, mês e ano, adiciona ao total
        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransactions[i].value;
        }
      }

      // Nomes dos dias da semana (abreviados)
      const weekDayNames = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

      // Retorna um mapa com o dia da semana e o valor total das transações
      return {
        'day': weekDayNames[weekDay.weekday % 7], // Adaptação para o índice
        'value': totalSum,
      };
    })
        .reversed
        .toList(); // Inverte a lista para mostrar do dia mais antigo ao mais recente
  }

  // Getter que calcula o valor total da semana
  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + (tr['value'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.sizeOf(context).height/5) , // Define a altura do container
      child: Card(    
        elevation: 1, // Elevação do cartão para sombra
        margin: const EdgeInsets.all(15), // Margem ao redor do cartão
        child: Container(
          padding: EdgeInsets.all(10), // Espaçamento interno do container
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceAround, // Espaçamento uniforme entre as barras
            children: groupedTransactions.map((tr) {
              return Flexible(
                fit: FlexFit
                    .tight, // As barras ocupam espaço disponível uniformemente
                child: ChartBar(
                  label: tr['day'].toString(), // Rótulo do dia
                  value: (tr['value'] as double), // Valor do dia
                  percentage: _weekTotalValue == 0
                      ? 0
                      : (tr['value'] as double) /
                          _weekTotalValue, // Porcentagem do total semanal
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
