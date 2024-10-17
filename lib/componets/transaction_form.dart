import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Um widget com estado que representa um formulário para adicionar transações
class TransactionForm extends StatefulWidget {
  // Função de callback que será chamada ao submeter o formulário
  final void Function(String, double, DateTime) onSubmit;

  // Construtor que recebe a função de callback
  TransactionForm({super.key, required this.onSubmit});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

// Estado associado ao TransactionForm
class _TransactionFormState extends State<TransactionForm> {
  // Controladores para os campos de texto
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime? _selectedDate; // Data selecionada pelo usuário

  // Função que submete o formulário
  _submitForm() {
    final title = _titleController.text; // Obtém o título
    final value =
        double.tryParse(_valueController.text) ?? 0.0; // Obtém o valor

    // Verifica se os campos estão preenchidos corretamente
    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return; // Sai da função se houver erro
    }

    // Chama a função de callback com os dados do formulário
    widget.onSubmit(title, value, _selectedDate!);

    // Limpa os campos do formulário
    _titleController.text = '';
    _valueController.text = '';
  }

  // Função que exibe o seletor de data
  _showDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime(2019), // Data mínima
      lastDate: DateTime.now(), // Data máxima
    ).then((pickedDate) {
      // Atualiza a data selecionada
      _selectedDate = pickedDate!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1, // Elevação do cartão para sombra
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Espaçamento interno
        child: Container(
          margin: const EdgeInsets.all(10), // Margem ao redor do container
          child: Column(
            children: [
              // Campo de texto para o título
              TextField(
                controller: _titleController,
                onSubmitted: (_) =>
                    _submitForm(), // Submete ao pressionar Enter
                decoration: const InputDecoration(labelText: 'Titulo'),
              ),
              // Campo de texto para o valor
              TextField(
                controller: _valueController,
                keyboardType:
                    const TextInputType.numberWithOptions(), // Tipo numérico
                onSubmitted: (_) =>
                    _submitForm(), // Submete ao pressionar Enter
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
              ),
              Container(
                height: 70, // Altura do container
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'Nenhuma data selecionada' // Texto padrão
                            : 'Data selecionada: ${DateFormat('dd/MM/yyyy', 'pt_Br').format(_selectedDate!)}', // Data formatada
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context)
                            .colorScheme
                            .primary, // Cor do texto
                      ),
                      onPressed: _showDatePicker, // Abre o seletor de data
                      child: const Text('Selecionar data'),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Alinha o botão à direita
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.primary, // Cor de fundo
                      foregroundColor: Colors.white, // Cor do texto
                    ),
                    onPressed: _submitForm, // Submete o formulário
                    child: const Text('Nova transação'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
