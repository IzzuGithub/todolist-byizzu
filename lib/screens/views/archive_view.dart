import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/todo_item.dart';
import '../../widgets/task_card.dart';
import '../detail_todo_page.dart';

class ArchiveView extends StatefulWidget {
  final List<TodoItem> todoList;
  const ArchiveView({Key? key, required this.todoList}) : super(key: key);
  @override
  State<ArchiveView> createState() => _ArchiveViewState();
}

class _ArchiveViewState extends State<ArchiveView> {
  int? _year;
  int? _month;

  @override
  Widget build(BuildContext context) {
    // Logika Filter
    List<TodoItem> filtered = [];
    if(_year != null) {
      filtered = widget.todoList.where((i) =>
      !i.isRoutine &&
          i.deadline != null &&
          i.deadline!.year == _year &&
          (_month == null || i.deadline!.month == _month)
      ).toList();
    }

    return Column(
        children: [
          // Dropdown Tahun & Bulan
          Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                  children: [
                    Expanded(
                        child: DropdownButtonFormField<int>(
                            value: _year,
                            decoration: const InputDecoration(
                                labelText: "Tahun",
                                border: OutlineInputBorder()
                            ),
                            items: List.generate(5, (i) => DateTime.now().year + i)
                                .map((y) => DropdownMenuItem(value: y, child: Text("$y")))
                                .toList(),
                            onChanged: (v) => setState((){ _year = v; _month = null; })
                        )
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: DropdownButtonFormField<int>(
                            value: _month,
                            decoration: const InputDecoration(
                                labelText: "Bulan",
                                border: OutlineInputBorder()
                            ),
                            items: List.generate(12, (i) => i + 1)
                                .map((m) => DropdownMenuItem(
                                value: m,
                                child: Text(DateFormat('MMMM', 'id_ID').format(DateTime(2022, m)))
                            ))
                                .toList(),
                            onChanged: _year == null
                                ? null
                                : (v) => setState(() => _month = v)
                        )
                    ),
                  ]
              )
          ),

          // List Hasil (Menggunakan Expanded agar sisa layar terisi list)
          Expanded(
              child: _year == null
                  ? const Center(child: Text("Pilih Tahun & Bulan"))
                  : (filtered.isEmpty
                  ? const Center(child: Text("Tidak ada arsip."))
                  : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: filtered.length,
                  itemBuilder: (c, i) => TaskCard(
                      item: filtered[i],
                      showActions: false,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => DetailTodoPage(todo: filtered[i])))
                  )
              )
              )
          )
        ]
    );
  }
}