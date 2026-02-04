import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/globals.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _name;
  late TextEditingController _addr;
  late TextEditingController _job;
  late TextEditingController _pob;
  late TextEditingController _dob;

  String _selectedCountry = "Indonesia";
  String _selectedStatus = "Belum Menikah";
  String _selectedBlood = "A";
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: currentUser!.name);
    _addr = TextEditingController(text: currentUser!.address);
    _job = TextEditingController(text: currentUser!.job);
    _pob = TextEditingController(text: currentUser!.pob);
    _dob = TextEditingController(text: currentUser!.dob);

    _selectedCountry = countryData.any((c) => c['name'] == currentUser!.country) ? currentUser!.country : "Indonesia";
    _selectedStatus = ["Belum Menikah", "Menikah", "Cerai"].contains(currentUser!.maritalStatus) ? currentUser!.maritalStatus : "Belum Menikah";
    _selectedBlood = ["A", "B", "AB", "O", "-"].contains(currentUser!.bloodType) ? currentUser!.bloodType : "-";

    if (currentUser!.imagePath != null && currentUser!.imagePath!.isNotEmpty) {
      _imageFile = File(currentUser!.imagePath!);
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
  }

  void _pickDOB() async {
    FocusScope.of(context).unfocus();

    await Future.delayed(const Duration(milliseconds: 200));

    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),

      initialEntryMode: DatePickerEntryMode.calendar,

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),

          child: isLandscape
              ? _buildLandscapeDatePicker(child!)
              : child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _dob.text = DateFormat('dd-MM-yy').format(picked));
    }
  }

  // Widget pembantu untuk mengecilkan kalender saat Landscape
  Widget _buildLandscapeDatePicker(Widget child) {
    return SingleChildScrollView(
      child: Container(
        // Beri margin agar tidak nempel pinggir layar
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Transform.scale(
          scale: 0.85, // Skala 85% dari ukuran asli (biar muat)
          child: child,
        ),
      ),
    );
  }

  void _save() {
    // 1. TUTUP KEYBOARD DULU
    FocusScope.of(context).unfocus();

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

      if (_imageFile != null) {
        currentUser!.imagePath = _imageFile!.path;
      }
    });

    // Beri jeda sedikit sebelum menutup halaman agar animasi keyboard selesai
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) Navigator.pop(context);
    });
  }

  Future<bool> _onWillPop() async {
    // 1. WAJIB: Tutup keyboard terlebih dahulu!
    FocusScope.of(context).unfocus();

    // 2. Beri jeda sedikit (300ms) agar animasi keyboard turun selesai dulu
    // sebelum dialog muncul. Ini mencegah dialog 'terjepit'.
    await Future.delayed(const Duration(milliseconds: 300));

    return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          // 3. TAMBAHAN PENTING: scrollable: true
          // Ini membuat isi dialog bisa digulir jika layar sangat pendek
            scrollable: true,

            title: const Text('Batalkan Perubahan?'),
            content: const Text('Apakah kamu yakin ingin kembali? Perubahan tidak akan disimpan.'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Tidak')
              ),
              TextButton(
                  onPressed: () {
                    // Pastikan keyboard benar-benar mati sebelum pop
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Ya')
              )
            ]
        )
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          // Tambahkan ini: Mengizinkan body menyesuaikan keyboard,
          // tapi karena kita sudah unfocus(), ini jadi lebih aman.
            resizeToAvoidBottomInset: true,

            appBar: AppBar(
              title: const Text("Edit Profil"),
              // ... code lainnya ...
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Sembunyikan foto saat landscape agar fokus mengisi data
                  if (!isLandscape) ...[
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                            child: _imageFile == null ? const Icon(Icons.person, size: 60, color: Colors.grey) : null,
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: InkWell(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  _f(_name, "Nama Lengkap"),
                  _f(_addr, "Alamat"),
                  _f(_job, "Pekerjaan"),

                  DropdownButtonFormField<String>(
                      value: _selectedCountry,
                      decoration: const InputDecoration(labelText: "Negara", border: OutlineInputBorder()),
                      items: countryData.map((c) => DropdownMenuItem(value: c['name'], child: Text("${c['name']} (${c['code']})"))).toList(),
                      onChanged: (v) => setState(() => _selectedCountry = v!)
                  ),
                  const SizedBox(height: 15),

                  // --- PERUBAHAN UTAMA DI SINI ---
                  // Row dihapus, diganti menjadi urutan vertikal biasa (atas-bawah)

                  // 1. Tempat Lahir (Full Width)
                  _f(_pob, "Tempat Lahir"),

                  // 2. Tanggal Lahir (Full Width)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: InkWell(
                      onTap: _pickDOB,
                      child: IgnorePointer(
                        child: TextField(
                          controller: _dob,
                          decoration: const InputDecoration(
                            labelText: "Tanggal Lahir",
                            hintText: "DD-MM-YY",
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // -------------------------------

                  DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(labelText: "Status", border: OutlineInputBorder()),
                      items: ["Belum Menikah", "Menikah", "Cerai"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _selectedStatus = v!)
                  ),
                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                      value: _selectedBlood,
                      decoration: const InputDecoration(labelText: "Golongan Darah", border: OutlineInputBorder()),
                      items: ["A", "B", "AB", "O", "-"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _selectedBlood = v!)
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontSize: 16))
                    ),
                  ),
                  // Spacer tambahan agar bisa scroll mentok bawah saat landscape
                  const SizedBox(height: 200),
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
