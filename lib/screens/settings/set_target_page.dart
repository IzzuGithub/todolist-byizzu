import 'package:flutter/material.dart';
import '../../data/globals.dart';

class SetTargetPage extends StatefulWidget {
  const SetTargetPage({Key? key}) : super(key: key);
  @override
  State<SetTargetPage> createState() => _SetTargetPageState();
}
class _SetTargetPageState extends State<SetTargetPage> {
  final _ctrl = TextEditingController(text: currentUser!.dailyGoal.toString());
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Target Harian"), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [const Text("Masukkan limit tugas harian:"), const SizedBox(height: 10), TextField(controller: _ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(border: OutlineInputBorder())), const SizedBox(height: 20), ElevatedButton(onPressed: (){ int? v = int.tryParse(_ctrl.text); if(v!=null && v>0) { setState(() => currentUser!.dailyGoal = v); Navigator.pop(context); }}, child: const Text("Simpan"))])));
  }
}