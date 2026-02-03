import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("FAQ"), backgroundColor: Colors.white, foregroundColor: Colors.black), body: ListView(padding: const EdgeInsets.all(16), children: const [
      ExpansionTile(title: Text("Bagaimana cara membuat ToDoList?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Klik icon tambah (+) yang ada di tengah navbar bawah. Kemudian pilih jenis ToDoList yang kamu inginkan"))]),
      ExpansionTile(title: Text("Apa Saja Jenis ToDoList?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Jenis ToDoList terdiri dari 2 yaiut ToDoList Rutin dna ToDoList Deadline"))]),
      ExpansionTile(title: Text("Apa perbedaan ToDoList kegiatan rutin dengan ToDoList deadline?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Perbedaan kedua ToDoList tersebut terletak pada waktu. ToDoList kegiatan rutin bisa dibuat berulang dengan patokan hari sedangkan ToDoList deadline menggunakan patokan tanggal, bulan dan tahun yang dijadikan sebagai deadline"))]),
      ExpansionTile(title: Text("Bagaimana jika ToDoList Deadline tidak dikerjakan sesuai deadline?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Maka ToDoList tersebut akan ditandai dengan terlambat."))]),
      ExpansionTile(title: Text("Apakah ToDoList bisa tidak memiliki deadline?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Tentu Saja Bisa!, dibagian ToDoList deadline terlihat checkbox tidak ada dealdine tapi ingat ketika ToDoList ini diabaikan maka akan ditandai dengan diabaikan."))]),
      ExpansionTile(title: Text("Berapa limit untuk membuat ToDoList"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Sesuai kuota tugas yang anda inginkan. Semisal hari ini saya akan membuat 10 tugas maka limitnya juga 10. Untuk batas membuat target itu tidak ada ya!"))]),
      ExpansionTile(title: Text("Apa fungsi navbar jadwal?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Untuk menampung dan menampilkan todolist yang dilabeli kegiatan rutin."))]),
      ExpansionTile(title: Text("Apa saja warna kategori ToDoList?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Sekolah: Biru\nKuliah: Ungu\nKerja: Ungu Muda\nOlahraga: Hijau Muda\nLiburan: Kuning\nRumah: Merah Muda\nHobi: Hijau\nBerpergian: Biru Muda\nBersih-Bersih: Hijau Muda Muda\nBelanja: Kuning Muda\nKesehatan: Merah Muda Muda\nLainnya: Abu-abu"))]),
      ExpansionTile(title: Text("Arti Warna Status?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Hijau: Selesai\nMerah: Terlambat\nAbu-abu: Diabaikan\nBiru: Deadline"))]),
      ExpansionTile(title: Text("Apa itu Kegiatan Rutin?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Tugas berulang setiap hari tertentu. Tidak mengurangi kuota harian."))]),
      ExpansionTile(title: Text("Fungsi Simpan Permanen?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Mengunci target harian. Tugas tanpa deadline yang belum selesai otomatis 'Diabaikan'."))]),
      ExpansionTile(title: Text("Fungsi Simpan Sementara?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Menyimpan tugas yang bersifat sementara. tugas yang disimpan sementara otomatis akan dimasukkan kedalam riwayat"))]),
      ExpansionTile(title: Text("Apa Fungsi Riwayat Page?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Riwayat Page adalah halaman yang menampilkan riwayat tugas mulai dari yang diselesaikan, tidak selesai, terlambat. dan diabiakan. Riwayat ini dihitung dari 1 hari yang lalu sampai minggu hari yang lalu."))]),
      ExpansionTile(title: Text("Apa Fungsi Jadwal Page?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Halaman yang menampilkan jadwal berdasarkan hari dari minggu sampai sabtu."))]),
      ExpansionTile(title: Text("Apa Fungsi Arsip Page?"), children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Untuk menyimpan tugas yang sudah selesai dan tidak selesai. Mencari riwayat tugas yang sudah lama dengan filter tahun dan bulan."))]),
    ]));
  }
}