import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_item.dart';
import '../data/globals.dart';

class AddTodoPage extends StatefulWidget {
  final bool isRoutineMode;
  const AddTodoPage({Key? key, required this.isRoutineMode}) : super(key: key);
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDate; TimeOfDay? _selectedTime;
  bool _isFavorite = false; bool _isImportant = false; bool _noDeadline = false;
  List<bool> _selectedDays = List.generate(7, (index) => false);
  TimeOfDay? _routineTime;
  String _selectedCategory = 'Sekolah';

  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));
    if (date != null) {
      final TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (time != null) {
        if (date.year == DateTime.now().year && date.month == DateTime.now().month && date.day == DateTime.now().day) {
          final now = TimeOfDay.now();
          if (time.hour < now.hour || (time.hour == now.hour && time.minute < now.minute)) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Waktu sudah berlalu!"), backgroundColor: Colors.red)); return;
          }
        }
        setState(() { _selectedDate = date; _selectedTime = time; });
      }
    }
  }

  Future<void> _pickRoutineTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );

    if (time != null) setState(() => _routineTime = time);
  }

  void _saveTodo() {
    if (_titleController.text.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Judul wajib diisi!'))); return; }

    // Validasi Rutin
    if (widget.isRoutineMode && (!_selectedDays.contains(true) || _routineTime == null)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lengkapi jadwal rutin!'))); return;
    }

    // Validasi Deadline (Jika bukan rutin & bukan no deadline)
    if (!widget.isRoutineMode && !_noDeadline && (_selectedDate == null || _selectedTime == null)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tentukan deadline atau pilih "Tidak ada deadline"'))); return;
    }

    DateTime? finalDeadline;
    if (!widget.isRoutineMode && !_noDeadline && _selectedDate != null && _selectedTime != null) {
      finalDeadline = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _selectedTime!.hour, _selectedTime!.minute);
    }

    Navigator.pop(context, TodoItem(
        title: _titleController.text, description: _descController.text, deadline: finalDeadline, category: _selectedCategory, icon: Icons.circle,
        isRoutine: widget.isRoutineMode, routineDays: widget.isRoutineMode ? [for(int i=0; i<7; i++) if(_selectedDays[i]) i] : [], routineTime: _routineTime,
        isFavorite: _isFavorite, isImportant: _isImportant, isIgnored: false
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(widget.isRoutineMode ? "Tambah Kegiatan Rutin" : "Tambah Tugas Deadline"), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0, leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(24.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Judul", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)), TextField(controller: _titleController, decoration: const InputDecoration(hintText: "Contoh: Kerjakan PR")), const SizedBox(height: 20),
        const Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)), TextField(controller: _descController, maxLines: 2, decoration: const InputDecoration(hintText: "Detail tugas...")), const SizedBox(height: 20),

        if (!widget.isRoutineMode) ...[
          CheckboxListTile(title: const Text("Penting"), value: _isImportant, activeColor: AppColors.accentOrange, onChanged: (val) => setState(() => _isImportant = val!)),
          CheckboxListTile(title: const Text("Favorit"), value: _isFavorite, activeColor: AppColors.accentOrange, onChanged: (val) => setState(() => _isFavorite = val!)),
          CheckboxListTile(title: const Text("Tidak ada deadline"), value: _noDeadline, activeColor: Colors.grey, onChanged: (val) => setState(() => _noDeadline = val!)),
          if (!_noDeadline) ListTile(contentPadding: EdgeInsets.zero, title: Text(_selectedDate == null ? "Pilih Deadline" : "${DateFormat('dd MMM HH:mm').format(DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day, _selectedTime!.hour, _selectedTime!.minute))}", style: const TextStyle(fontWeight: FontWeight.bold)), trailing: const Icon(Icons.calendar_today, color: AppColors.primary), onTap: _pickDateTime),
        ],

        if (widget.isRoutineMode) ...[
          const Text("Pilih Hari:", style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 10),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: ToggleButtons(isSelected: _selectedDays, onPressed: (index) => setState(() => _selectedDays[index] = !_selectedDays[index]), children: const [Text("M"), Text("S"), Text("S"), Text("R"), Text("K"), Text("J"), Text("S")])),
          ListTile(contentPadding: EdgeInsets.zero, title: Text(_routineTime == null ? "Pilih Jam" : "${_routineTime!.format(context)} WIB", style: const TextStyle(fontWeight: FontWeight.bold)), trailing: const Icon(Icons.alarm, color: AppColors.primary), onTap: _pickRoutineTime),
        ],

        const Divider(height: 30), const Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)), const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: categoryColors.keys.map((c) => ChoiceChip(
            label: Text(c),
            avatar: Icon(categoryIcons[c], size: 16, color: _selectedCategory == c ? Colors.white : categoryColors[c]),
            selected: _selectedCategory == c,
            selectedColor: categoryColors[c],
            onSelected: (b) => setState(() => _selectedCategory = c))
        ).toList()),

        const SizedBox(height: 30), SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _saveTodo, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("Simpan", style: TextStyle(fontSize: 16, color: Colors.white))))
      ])),
    );
  }
}