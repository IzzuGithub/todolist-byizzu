import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/globals.dart';
import '../../models/todo_item.dart';
import '../../widgets/task_card.dart';
import '../detail_todo_page.dart';
import '../settings/set_target_page.dart';

class DashboardView extends StatelessWidget {
  final List<TodoItem> todoList;
  final Function(int) onDelete;
  final Function(int, bool) onToggle;
  final Function(int) onFav;
  final VoidCallback onReset;
  final Function(int, bool) onSaveTarget;
  final VoidCallback onRefresh; // Parameter baru

  const DashboardView({
    Key? key,
    required this.todoList,
    required this.onDelete,
    required this.onToggle,
    required this.onFav,
    required this.onReset,
    required this.onSaveTarget,
    required this.onRefresh,
  }) : super(key: key);

  List<PieChartSectionData> _getChartSections(List<TodoItem> list) {
    Map<String, int> categories = {};
    int total = 0;
    for (var item in list) {
      if (!item.isRoutine) {
        categories[item.category] = (categories[item.category] ?? 0) + 1;
        total++;
      }
    }
    if (total == 0) return [];
    return categories.entries.map((entry) {
      double percent = (entry.value / total) * 100;
      return PieChartSectionData(color: categoryColors[entry.key] ?? Colors.grey, value: entry.value.toDouble(), title: '${percent.toStringAsFixed(0)}%', radius: 25, titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<TodoItem> dashboardList = todoList.where((item) => !item.isRoutine).toList();

    int totalCreated = dashboardList.length;
    int totalSelesai = dashboardList.where((i) => i.isCompleted).length;
    int target = currentUser!.dailyGoal;
    double completionRate = (totalCreated == 0) ? 0.0 : (totalSelesai / totalCreated);
    bool isLimitReached = totalCreated >= target && target > 0;

    int statSelesai = totalSelesai;
    int statTerlambat = dashboardList.where((i) => i.isOverdue).length;
    int statDiabaikan = dashboardList.where((i) => i.isIgnored).length;
    int statAktif = dashboardList.where((i) => !i.isCompleted && !i.isOverdue && !i.isIgnored).length;

    return SingleChildScrollView(
      child: Column(
        children: [

          Container(
            margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Halo, ${currentUser!.name}!", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text("${(completionRate * 100).toInt()}% Selesai", style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)), child: Text("$totalCreated / $target Target", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ])),
              SizedBox(width: 80, height: 80, child: Stack(alignment: Alignment.center, children: [CircularProgressIndicator(value: completionRate, strokeWidth: 8, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation<Color>(Colors.white)), const Icon(Icons.task_alt, color: Colors.white, size: 30)])),
            ]),
          ),


          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
            child: dashboardList.isEmpty
                ? Center(child: Column(children: [Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200, width: 10)), child: const Center(child: Text("0%", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)))), const SizedBox(height: 10), const Text("Tidak ada tugas hari ini", style: TextStyle(color: Colors.grey))]))
                : Row(children: [
              Expanded(flex: 3, child: SizedBox(height: 120, child: PieChart(PieChartData(sections: _getChartSections(dashboardList), centerSpaceRadius: 25, sectionsSpace: 2, borderData: FlBorderData(show: false))))),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: categoryColors.entries.where((e) => dashboardList.any((t) => t.category == e.key)).take(4).map((e) => Padding(padding: const EdgeInsets.symmetric(vertical: 2), child: Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: e.value, shape: BoxShape.circle)), const SizedBox(width: 5), Expanded(child: Text(e.key, style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis))]))).toList())),
            ]),
          ),


          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)]),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Statistik Harian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh, color: AppColors.primary),
                      onPressed: onRefresh,
                      tooltip: "Reload Target",
                    ),
                    GestureDetector(
                      onTap: () {
                        if (currentUser!.isTargetPermanent) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Target terkunci."))); } else { Navigator.push(context, MaterialPageRoute(builder: (c) => const SetTargetPage())); }
                      },
                      child: Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(currentUser!.isTargetPermanent ? Icons.lock : Icons.edit_note, size: 20, color: Colors.indigo)),
                    ),
                  ],
                )
              ]),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _statItem("Selesai", statSelesai, Colors.green), _statItem("Aktif", statAktif, Colors.blue), _statItem("Terlambat", statTerlambat, Colors.red), _statItem("Diabaikan", statDiabaikan, Colors.grey),
              ]),
              const Divider(height: 25),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Slot Terisi:", style: TextStyle(color: Colors.grey)), Text("$totalCreated / $target Tugas", style: TextStyle(fontWeight: FontWeight.bold, color: isLimitReached ? Colors.red : Colors.indigo, fontSize: 16))]),
            ]),
          ),


          if (isLimitReached && !currentUser!.isTargetPermanent)
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [
              Expanded(child: OutlinedButton(onPressed: () => onSaveTarget(target, false), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Simpan Sementara"))),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(onPressed: () => onSaveTarget(target, true), style: ElevatedButton.styleFrom(backgroundColor: AppColors.accentGreen, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Simpan Permanen"))),
            ])),


          if (!currentUser!.isTargetPermanent && totalCreated > 0)
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10), child: SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: onReset, icon: const Icon(Icons.refresh), label: const Text("Reset ToDo List"), style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))))),

          ListView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), padding: const EdgeInsets.fromLTRB(0, 10, 0, 100),
            itemCount: dashboardList.length,
            itemBuilder: (context, index) {
              int realIndex = todoList.indexOf(dashboardList[index]);
              return TaskCard(item: todoList[realIndex], onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => DetailTodoPage(todo: todoList[realIndex]))), onToggleStatus: (val) => onToggle(realIndex, val!), onDelete: () => onDelete(realIndex), onFavorite: () => onFav(realIndex));
            },
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, int value, Color color) {
    return Column(children: [Text(value.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)), Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey))]);
  }
}
