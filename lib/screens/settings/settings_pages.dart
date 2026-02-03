import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);
  void _launchURL(String url) async { if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url'; }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Contact Us"), backgroundColor: Colors.white, foregroundColor: Colors.black), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      Card(elevation: 4, margin: const EdgeInsets.only(bottom: 15), child: ListTile(leading: const Icon(Icons.chat, color: Colors.green), title: const Text("WhatsApp"), subtitle: const Text("082331362037"), onTap: () => _launchURL("https://wa.me/6282331362037"))),
      Card(elevation: 4, margin: const EdgeInsets.only(bottom: 15), child: ListTile(leading: const Icon(Icons.camera_alt, color: Colors.purple), title: const Text("Instagram"), subtitle: const Text("@rozaky.06"), onTap: () => _launchURL("https://instagram.com/rozaky.06"))),
    ])));
  }
}

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("FAQ"), backgroundColor: Colors.white, foregroundColor: Colors.black), body: ListView(padding: const EdgeInsets.all(16), children: const [
      ExpansionTile(title: Text("Arti Warna Status?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Hijau: Selesai\nMerah: Terlambat\nAbu-abu: Diabaikan (Tidak dikerjakan tanpa deadline)\nBiru: Memiliki Deadline\nKuning: Penting"))]),
      ExpansionTile(title: Text("Apa itu Kegiatan Rutin?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Tugas berulang setiap hari tertentu. Tidak bisa diselesaikan (checklist), hanya sebagai pengingat jadwal."))]),
      ExpansionTile(title: Text("Fungsi Simpan Permanen?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Mengunci target harian. Setelah dikunci, tugas tidak bisa dihapus atau diubah statusnya. Tugas tanpa deadline yang belum selesai akan otomatis dianggap 'Diabaikan'."))]),
      ExpansionTile(title: Text("Penjelasan Navbar?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Home: Dashboard Tugas Harian\nJadwal: Daftar Rutinitas & Tugas Hari Ini\nArsip: Melihat Tugas Lampau (Filter Bulan/Tahun)\nRiwayat: Log Tugas Selesai/Gagal"))]),
    ]));
  }
}