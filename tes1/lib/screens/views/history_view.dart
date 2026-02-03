import 'package:flutter/material.dart';
import '../../models/todo_item.dart';
import '../../data/globals.dart'; // Import data global untuk warna
import '../../widgets/task_card.dart';
import '../detail_todo_page.dart';

class HistoryView extends StatelessWidget {
  final List<TodoItem> todoList;
  const HistoryView({Key? key, required this.todoList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    // Wadah untuk list yang sudah difilter
    List<TodoItem> listHariIni = [];
    List<TodoItem> list3HariLalu = [];
    List<TodoItem> listMingguLalu = [];

    // --- LOGIKA PEMISAHAN LIST ---
    for (var item in todoList) {
      if (item.isRoutine) continue;

      // Filter: Hanya yang statusnya 'Final' (Selesai, Terlambat, Diabaikan)
      if (!item.isCompleted && !item.isOverdue && !item.isIgnored) continue;

      DateTime? refDate = item.completedAt ?? item.deadline;

      if (refDate == null) {
        if (item.isIgnored) listHariIni.add(item);
        continue;
      }

      int diff = now.difference(refDate).inDays;

      if (diff == 0) {
        listHariIni.add(item);
      } else if (diff > 0 && diff <= 3) {
        list3HariLalu.add(item);
      } else if (diff > 3 && diff <= 7) {
        listMingguLalu.add(item);
      }
    }

    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10), // Spasi atas pengganti header

              // 1. BAGIAN HARI INI (Selalu Tampil)
              _sectionHeader("Hari Ini", Icons.today, Colors.blue),
              if (listHariIni.isEmpty)
                _emptyState()
              else
                ...listHariIni.map((e) => _card(e, context)),

              // 2. BAGIAN 3 HARI LALU (Selalu Tampil)
              _sectionHeader("3 Hari Lalu", Icons.restore, Colors.orange),
              if (list3HariLalu.isEmpty)
                _emptyState()
              else
                ...list3HariLalu.map((e) => _card(e, context)),

              // 3. BAGIAN MINGGU LALU (Selalu Tampil)
              _sectionHeader("Minggu Lalu", Icons.calendar_view_week, Colors.purple),
              if (listMingguLalu.isEmpty)
                _emptyState()
              else
                ...listMingguLalu.map((e) => _card(e, context)),

              const SizedBox(height: 80) // Padding bawah
            ]
        )
    );
  }

  // Widget Header Per-Section
  Widget _sectionHeader(String title, IconData icon, Color color) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(width: 10),
          Expanded(child: Divider(color: Colors.grey.shade200, thickness: 2)),
        ],
      )
  );

  // Widget Tampilan Jika Kosong
  Widget _emptyState() => const Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Text(
        "Tidak ada riwayat.",
        style: TextStyle(color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic)
    ),
  );

  // Helper Card
  Widget _card(TodoItem item, BuildContext context) => TaskCard(
      item: item,
      showActions: false,
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => DetailTodoPage(todo: item)))
  );
}