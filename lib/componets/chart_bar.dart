import 'package:flutter/material.dart';

// Um widget sem estado que representa uma única barra em um gráfico
class ChartBar extends StatelessWidget {
  // Rótulo para a barra, valor a ser exibido e porcentagem da barra a ser preenchida
  final String label;
  final double value;
  final double percentage;

  // Construtor para ChartBar, exigindo rótulo, valor e porcentagem
  const ChartBar({
    super.key,
    required this.label,
    required this.value,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container para exibir o valor como texto
        Container(
          height: 20,
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: FittedBox(
            child: Text(
              'R\$${value.toStringAsFixed(2)}', // Formata o valor como moeda
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .primary // Usa a cor primária do tema
                  ),
            ),
          ),
        ),
        const SizedBox(
          height: 5, // Espaço entre o texto do valor e a barra
        ),
        // Container para representar a própria barra
        Container(
          height: 60,
          width: 10,
          child: Stack(
            alignment:
                Alignment.bottomCenter, // Alinha os filhos na parte inferior
            children: [
              // Fundo da barra
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // Borda cinza
                    width: 1.0,
                  ),
                  color: Colors.blueGrey[100], // Cor de fundo cinza claro
                  borderRadius: BorderRadius.circular(5), // Cantos arredondados
                ),
              ),
              // Parte preenchida da barra, baseada na porcentagem
              FractionallySizedBox(
                heightFactor:
                    percentage, // Preenche a barra de acordo com a porcentagem
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary, // Cor de preenchimento primária
                    borderRadius:
                        BorderRadius.circular(5), // Cantos arredondados
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5, // Espaço entre a barra e o rótulo
        ),
        // Widget de texto para exibir o rótulo abaixo da barra
        Text(label),
      ],
    );
  }
}
