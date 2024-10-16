import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double) onSubmit;

  TransactionForm({super.key, required this.onSubmit});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();

  final valueController = TextEditingController();

  _submitForm() {
    final title = titleController.text;
    final value = double.tryParse(valueController.text) ?? 0.0;
    if (title.isEmpty || value <= 0) {
      return;
    }
    widget.onSubmit(title, value);
    titleController.text = '';
    valueController.text = '';

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(labelText: 'Titulo'),
              ),
              TextField(
                controller: valueController,
                keyboardType: const TextInputType.numberWithOptions(),
                onSubmitted: (_) => _submitForm(),
                decoration: const InputDecoration(labelText: 'Valor (R\$)'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: _submitForm,
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
