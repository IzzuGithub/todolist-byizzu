import 'dart:io'; // Wajib untuk File
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // Wajib ada di pubspec.yaml
import '../../data/globals.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controller Text
  late TextEditingController _name;
  late TextEditingController _addr;
  late TextEditingController _job;
  late TextEditingController _pob;
  late TextEditingController _dob;

  // State Dropdown
  String _selectedCountry = "Indonesia";
  String _selectedStatus = "Belum Menikah";
  String _selectedBlood = "A";

  // State Foto
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load data awal dari currentUser
    _name = TextEditingController(text: currentUser!.name);
    _addr = TextEditingController(text: currentUser!.address);
    _job = TextEditingController(text: currentUser!.job);
    _pob = TextEditingController(text: currentUser!.pob);
    _dob = TextEditingController(text: currentUser!.dob);

    // Load dropdown value (dengan validasi agar tidak error jika data lama tidak ada di list)
    _selectedCountry = countryData.any((c) => c['name'] == currentUser!.country) ? currentUser!.country : "Indonesia";
    _selectedStatus = ["Belum Menikah", "Menikah", "Cerai"].contains(currentUser!.maritalStatus) ? currentUser!.maritalStatus : "Belum Menikah";
    _selectedBlood = ["A", "B", "AB", "O", "-"].contains(currentUser!.bloodType) ? currentUser!.bloodType : "-";

    // Load Image path jika ada
    if (currentUser!.imagePath != null && currentUser!.imagePath!.isNotEmpty) {
      _imageFile = File(currentUser!.imagePath!);
    }
  }

  // --- FUNGSI AMBIL GAMBAR ---
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // --- FUNGSI TANGGAL LAHIR ---
  void _pickDOB() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1950),
        lastDate: DateTime.now()
    );
    if (picked != null) {
      setState(() => _dob.text = DateFormat('dd-MM-yy').format(picked));
    }
  }

  // --- FUNGSI SIMPAN ---
  void _save() {
    var countryInfo = countryData.firstWhere((c) => c['name'] == _selectedCountry);

    setState(() {
      currentUser!.name = _name.text;
      currentUser!.address = _addr.text;
      currentUser!.job = _job.text;
      currentUser!.country = _selectedCountry;
      currentUser!.countryCode = countryInfo['code']!;
      currentUser!.pob = _pob.text;
      currentUser!.dob = _dob.text;
      currentUser!.maritalStatus = _selectedStatus;
      currentUser!.bloodType = _selectedBlood;

      // Simpan Path Gambar
      if (_imageFile != null) {
        currentUser!.imagePath = _imageFile!.path;
      }
    });

    Navigator.pop(context);
  }

  // --- KONFIRMASI KEMBALI ---
  Future<bool> _onWillPop() async {
    return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Batalkan Perubahan?'),
            content: const Text('Apakah kamu yakin ingin kembali? Perubahan tidak akan disimpan.'),
            actions: <Widget>[
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Tidak')),
              TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Ya'))
            ]
        )
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Edit Profil"),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // --- BAGIAN FOTO PROFIL ---
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : null,
                          child: _imageFile == null
                              ? const Icon(Icons.person, size: 60, color: Colors.grey)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- FORM INPUT ---
                  _f(_name, "Nama Lengkap"),
                  _f(_addr, "Alamat"),
                  _f(_job, "Pekerjaan"),

                  DropdownButtonFormField<String>(
                      value: _selectedCountry,
                      decoration: const InputDecoration(labelText: "Negara", border: OutlineInputBorder()),
                      items: countryData.map((c) => DropdownMenuItem(value: c['name'], child: Row(children: [Text(c['flag']!), const SizedBox(width: 10), Text("${c['name']} (${c['code']})")]))).toList(),
                      onChanged: (v) => setState(() => _selectedCountry = v!)
                  ),
                  const SizedBox(height: 10),

                  Row(children: [
                    Expanded(child: _f(_pob, "Tempat Lahir")),
                    const SizedBox(width: 10),
                    Expanded(child: InkWell(onTap: _pickDOB, child: IgnorePointer(child: _f(_dob, "Tgl Lahir (DD-MM-YY)"))))
                  ]),

                  DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(labelText: "Status", border: OutlineInputBorder()),
                      items: ["Belum Menikah", "Menikah", "Cerai"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _selectedStatus = v!)
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField<String>(
                      value: _selectedBlood,
                      decoration: const InputDecoration(labelText: "Golongan Darah", border: OutlineInputBorder()),
                      items: ["A", "B", "AB", "O", "-"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _selectedBlood = v!)
                  ),

                  const SizedBox(height: 30),

                  // TOMBOL SIMPAN
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        ),
                        child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontSize: 16))
                    ),
                  )
                ]
            )
        )
    );
  }

  Widget _f(TextEditingController c, String l) => Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
          controller: c,
          decoration: InputDecoration(labelText: l, border: const OutlineInputBorder())
      )
  );
}