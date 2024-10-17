class MyTransaction {
  final String id;
  final String title;
  final double value;
  final DateTime date;

  MyTransaction({
    required this.id,
    required this.title,
    required this.value,
    required this.date,
  });

  // Convertendo MyTransaction para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'date': date.toIso8601String(),
    };
  }

  // Convertendo de Map para MyTransaction
  factory MyTransaction.fromMap(Map<String, dynamic> map) {
    return MyTransaction(
      id: map['id'],
      title: map['title'],
      value: map['value'],
      date: DateTime.parse(map['date']),
    );
  }
}
