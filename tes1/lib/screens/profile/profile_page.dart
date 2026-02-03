import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/globals.dart';
import 'package:tes1/screens/profile/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  void _openEdit() async {
    await Navigator.push(context, MaterialPageRoute(builder: (c) => const EditProfilePage()));
    setState(() {}); // Refresh setelah kembali
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, appBar: AppBar(title: const Text("Profil Saya"), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0, actions: [IconButton(icon: const Icon(Icons.edit), onPressed: _openEdit) ]),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
        CircleAvatar(radius: 50, backgroundColor: Colors.indigo.shade50, child: const Icon(Icons.person, size: 50, color: Colors.indigo)), const SizedBox(height: 10), Text(currentUser!.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 20),
        _item("Alamat", currentUser!.address), _item("Pekerjaan", currentUser!.job), _item("Negara", "${currentUser!.country} (${currentUser!.countryCode})"), _item("TTL", "${currentUser!.pob}, ${currentUser!.dob}"), _item("Status", currentUser!.maritalStatus), _item("Golongan Darah", currentUser!.bloodType),
      ])),
    );
  }
  Widget _item(String l, String v) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: const TextStyle(color: Colors.grey)), Text(v, style: const TextStyle(fontWeight: FontWeight.bold))]));
}
