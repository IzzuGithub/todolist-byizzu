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
  int? _year; int? _month;
  @override
  Widget build(BuildContext context) {
    List<TodoItem> filtered = [];
    if(_year!=null) filtered = widget.todoList.where((i) => !i.isRoutine && i.deadline != null && i.deadline!.year == _year && (_month == null || i.deadline!.month == _month)).toList();

    return Column(children: [
      Padding(padding: const EdgeInsets.all(16), child: Row(children: [
        Expanded(child: DropdownButtonFormField<int>(value: _year, hint: const Text("Tahun"), items: List.generate(5, (i)=>DateTime.now().year+i).map((y)=>DropdownMenuItem(value: y, child: Text("$y"))).toList(), onChanged: (v)=>setState((){_year=v;_month=null;}))),
        const SizedBox(width: 10),
        Expanded(child: DropdownButtonFormField<int>(value: _month, hint: const Text("Bulan"), items: List.generate(12, (i)=>i+1).map((m)=>DropdownMenuItem(value: m, child: Text(DateFormat('MMMM').format(DateTime(2022, m))))).toList(), onChanged: _year==null?null:(v)=>setState(()=>_month=v))),
      ])),
      Expanded(child: _year==null ? const Center(child: Text("Pilih Tahun & Bulan")) : (filtered.isEmpty ? const Center(child: Text("Kosong")) : ListView(children: filtered.map((e)=>TaskCard(item: e, showActions: false, onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (c)=>DetailTodoPage(todo: e))))).toList())))
    ]);
  }
}