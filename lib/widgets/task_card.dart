import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_item.dart';
import '../data/globals.dart';
import 'countdown_timer.dart';

class TaskCard extends StatelessWidget {
  final TodoItem item;
  final Function(bool?)? onToggleStatus;
  final VoidCallback? onFavorite;
  final VoidCallback? onDelete;
  final VoidCallback onTap;
  final bool showActions;

  const TaskCard({Key? key, required this.item, required this.onTap, this.onToggleStatus, this.onFavorite, this.onDelete, this.showActions = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color cardColor = item.isCompleted ? Colors.green : Colors.white;
    Color textColor = item.isCompleted ? Colors.white : AppColors.textDark;
    Color subTextColor = item.isCompleted ? Colors.white70 : AppColors.textGrey;
    Color iconColor = item.isCompleted ? Colors.white : (categoryColors[item.category] ?? Colors.grey);

    Color statusColor = AppColors.primary;
    String statusText = "";

    if (item.isRoutine) {
      statusColor = Colors.teal;
    } else if (item.isIgnored) {
      statusColor = Colors.grey; statusText = "Diabaikan";
    } else if (item.isCompleted) {
      statusColor = Colors.white; statusText = "Selesai";
    } else if (item.isOverdue) {
      statusColor = AppColors.accentRed; statusText = "Terlambat";
    } else if (item.deadline != null) {
      statusColor = AppColors.accentBlue;
    } else if (item.isImportant) {
      statusColor = AppColors.accentOrange;
    }

    bool canToggle = !(item.isOverdue || item.isIgnored) && !item.isRoutine;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))]
      ),
      child: InkWell(
        onTap: onTap, borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (!item.isCompleted) Container(width: 4, height: 40, decoration: BoxDecoration(color: categoryColors[item.category] ?? Colors.grey, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 12),
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: item.isCompleted ? Colors.white24 : (categoryColors[item.category]??Colors.grey).withOpacity(0.1), shape: BoxShape.circle), child: Icon(categoryIcons[item.category] ?? Icons.circle, color: iconColor, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(item.title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, decoration: item.isCompleted ? TextDecoration.lineThrough : null, color: textColor))),
                if (item.isFavorite && !item.isRoutine) Icon(Icons.star_rounded, color: item.isCompleted ? Colors.white : AppColors.accentOrange, size: 20),
                if (item.isImportant && !item.isRoutine) Padding(padding: const EdgeInsets.only(left: 5), child: Icon(Icons.priority_high_rounded, color: item.isCompleted ? Colors.white : AppColors.accentOrange, size: 18))
              ]),
              const SizedBox(height: 4),
              Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: subTextColor, fontSize: 13)),
              const SizedBox(height: 8),
              Row(children: [
                if (item.isRoutine && item.routineTime != null) Text("Setiap Hari, ${item.routineTime!.format(context)}", style: const TextStyle(fontSize: 11, color: Colors.teal, fontWeight: FontWeight.bold)),
                if (statusText.isNotEmpty && !item.isRoutine)
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: item.isCompleted ? Colors.white24 : statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(statusText, style: TextStyle(fontSize: 10, color: item.isCompleted ? Colors.white : statusColor, fontWeight: FontWeight.bold))
                  ),
                if (item.deadline != null && !item.isCompleted && !item.isRoutine && !item.isIgnored && !item.isOverdue) ...[
                  const SizedBox(width: 5),
                  const Icon(Icons.timer_outlined, size: 12, color: Colors.blueAccent),
                  const SizedBox(width: 4),
                  CountdownTimerWidget(deadline: item.deadline!)
                ]
              ])
            ])),
            if (showActions) PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: item.isCompleted ? Colors.white70 : Colors.grey),
              onSelected: (v) {
                if (v == 'toggle') onToggleStatus?.call(!item.isCompleted);
                if (v == 'fav') onFavorite?.call();
                if (v == 'delete') onDelete?.call();
              },
              itemBuilder: (context) {
                List<PopupMenuEntry<String>> menu = [];
                if (canToggle) menu.add(PopupMenuItem(value: 'toggle', child: Text(item.isCompleted ? "Batal Selesai" : "Selesai")));
                if (!item.isRoutine) menu.add(const PopupMenuItem(value: 'fav', child: Text("Favorit")));
                menu.add(const PopupMenuItem(value: 'delete', child: Text("Hapus", style: TextStyle(color: Colors.red))));
                return menu;
              },
            )
          ]),
        ),
      ),
    );
  }
}