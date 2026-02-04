import 'package:flutter/material.dart';
import '../../data/globals.dart'; // Pastikan path ini sesuai

class SetTargetPage extends StatefulWidget {
  const SetTargetPage({Key? key}) : super(key: key);

  @override
  State<SetTargetPage> createState() => _SetTargetPageState();
}

class _SetTargetPageState extends State<SetTargetPage> {
  final _ctrl = TextEditingController(text: currentUser!.dailyGoal.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Target Harian"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      // 1. LayoutBuilder untuk mendapatkan tinggi layar yang tersedia
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            // 2. SingleChildScrollView agar konten bisa digulir saat keyboard muncul
            child: ConstrainedBox(
              // 3. Memaksa tinggi minimal konten sama dengan tinggi layar
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                // 4. IntrinsicHeight diperlukan agar Flexible/Expanded bekerja dalam ScrollView
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text("Masukkan limit tugas harian:"),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _ctrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),

                      // 5. Flexible/Expanded sebagai Spacer
                      // Ini akan mendorong tombol ke bawah layar saat keyboard tertutup
                      // tetapi akan menyusut saat keyboard muncul (menghindari overflow)
                      const Expanded(child: SizedBox(height: 20)),

                      ElevatedButton(
                        onPressed: () {
                          int? v = int.tryParse(_ctrl.text);
                          if (v != null && v > 0) {
                            setState(() => currentUser!.dailyGoal = v);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Simpan"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
