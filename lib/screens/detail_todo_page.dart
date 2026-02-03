import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_item.dart';

class DetailTodoPage extends StatelessWidget {
  final TodoItem todo;
  const DetailTodoPage({Key? key, required this.todo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String status = todo.isCompleted ? "Selesai" : (todo.isOverdue ? "Terlambat" : (todo.isIgnored ? "Diabaikan" : "Aktif"));
    Color color = todo.isCompleted ? Colors.green : (todo.isOverdue ? Colors.red : (todo.isIgnored ? Colors.grey : Colors.blue));
    return Scaffold(appBar: AppBar(title: const Text("Detail"), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0), body: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(todo.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
      if(todo.isImportant) Chip(label: const Text("PENTING"), backgroundColor: Colors.red.shade100, labelStyle: const TextStyle(color: Colors.red)),
      const SizedBox(height: 20), _info("Kategori", todo.category), _info("Deskripsi", todo.description), _info("Status", status, color: color),
      if(todo.deadline!=null) _info("Jatuh Tempo", DateFormat('EEEE, d MMMM yyyy - HH:mm', 'id_ID').format(todo.deadline!)),
      if(todo.completedAt!=null) _info("Selesai Pada", DateFormat('EEEE, d MMMM yyyy - HH:mm', 'id_ID').format(todo.completedAt!)),
    ])));
  }
  Widget _info(String l, String v, {Color? color}) => Padding(padding: const EdgeInsets.only(bottom: 15), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: const TextStyle(color: Colors.grey)), Text(v, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color ?? Colors.black))]));
}