import 'package:flutter/material.dart';
import '../../models/todo_item.dart';
import '../../data/globals.dart';
import '../../widgets/task_card.dart';
import '../detail_todo_page.dart';

class ScheduleView extends StatefulWidget {
  final List<TodoItem> todoList;
  final Function(int) onDelete;
  const ScheduleView({Key? key, required this.todoList, required this.onDelete}) : super(key: key);

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  // Default hari ini (0=Minggu, 1=Senin... atau sesuaikan dengan data TodoItem)
  // Di AddTodo: 0=Minggu, 1=Senin...
  // DateTime.weekday: 1=Senin, 7=Minggu. Jadi kita konversi:
  // Jika weekday 7 (Minggu) -> index 0. Jika 1 (Senin) -> index 1.
  int _selectedDayIndex = DateTime.now().weekday == 7 ? 0 : DateTime.now().weekday;

  final List<String> _days = ["Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"];

  @override
  Widget build(BuildContext context) {
    // Filter Rutin: Cek apakah hari index ada di list routineDays
    List<TodoItem> filteredRoutineList = widget.todoList.where((item) {
      return item.isRoutine && item.routineDays.contains(_selectedDayIndex);
    }).toList();

    // Filter Harian: Cek apakah tugas deadline jatuh pada hari yang dipilih
    // (Logic sederhana: Jika deadline != null dan weekday cocok)
    List<TodoItem> filteredDailyList = widget.todoList.where((item) {
      if (item.isRoutine || item.deadline == null) return false;
      int itemDayIndex = item.deadline!.weekday == 7 ? 0 : item.deadline!.weekday;
      return itemDayIndex == _selectedDayIndex;
    }).toList();

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // WIDGET PILIHAN HARI
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(7, (index) {
                bool isSelected = _selectedDayIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(_days[index]),
                    selected: isSelected,
                    onSelected: (val) => setState(() => _selectedDayIndex = index),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    backgroundColor: Colors.white,
                  ),
                );
              }),
            ),
          ),
        ),

        Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 8), child: Text("Jadwal ${_days[_selectedDayIndex]}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),

        if (filteredRoutineList.isEmpty && filteredDailyList.isEmpty)
          const Padding(padding: EdgeInsets.all(20), child: Center(child: Text("Tidak ada jadwal pada hari ini.", style: TextStyle(color: Colors.grey)))),

        if (filteredRoutineList.isNotEmpty) ...[
          const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5), child: Text("Rutin", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange))),
          ...filteredRoutineList.map((e) => TaskCard(item: e, showActions: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => DetailTodoPage(todo: e))), onDelete: () => widget.onDelete(widget.todoList.indexOf(e)))),
        ],

        if (filteredDailyList.isNotEmpty) ...[
          const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5), child: Text("Tugas", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo))),
          ...filteredDailyList.map((e) => TaskCard(item: e, showActions: false, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => DetailTodoPage(todo: e))))),
        ],

        const SizedBox(height: 80)
      ]),
    );
  }
}