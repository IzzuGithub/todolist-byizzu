import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../data/globals.dart';
import '../models/todo_item.dart';
import '../utils/search_delegate.dart';

import 'views/dashboard_view.dart';
import 'views/schedule_view.dart';
import 'views/history_view.dart';
import 'views/archive_view.dart';
import 'add_todo_page.dart';
import 'detail_todo_page.dart';
import 'profile/profile_page.dart';
import 'settings/contact_us_page.dart';
import 'settings/faq_page.dart';
import 'settings/set_target_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  final List<TodoItem> _todoList = [];
  Timer? _dayCheckTimer;
  Timer? _notificationTimer;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isFabExpanded = false;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    WidgetsBinding.instance.addObserver(this);
    _checkDayChange();
    _dayCheckTimer = Timer.periodic(const Duration(minutes: 1), (timer) => _checkDayChange());
    _notificationTimer = Timer.periodic(const Duration(seconds: 10), (timer) => _checkDeadlines());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dayCheckTimer?.cancel();
    _notificationTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkDayChange();
      _checkDeadlines();
    }
  }

  void _checkDeadlines() {
    DateTime now = DateTime.now();
    for (var item in _todoList) {
      if (item.isCompleted || item.isRoutine || item.deadline == null) continue;
      Duration diff = item.deadline!.difference(now);
      if (diff.inMinutes <= 60 && diff.inMinutes > 5 && !item.notified1Hour) {
        item.notified1Hour = true;
        _showLocalNotification("Ingat!", "${item.title} jatuh tempo 1 jam lagi.");
      }
      if (diff.inMinutes <= 5 && diff.inMinutes > 0 && !item.notified5Min) {
        item.notified5Min = true;
        _showDeadlinePopup(item);
      }
    }
  }

  void _showLocalNotification(String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.notifications_active, color: Colors.white), const SizedBox(width: 10), Expanded(child: Text("$title: $message"))]), backgroundColor: AppColors.accentOrange, duration: const Duration(seconds: 5), behavior: SnackBarBehavior.floating, margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 150, left: 10, right: 10)));
  }

  void _showDeadlinePopup(TodoItem item) {
    showDialog(context: context, builder: (ctx) => AlertDialog(title: const Row(children: [Icon(Icons.warning, color: Colors.red), SizedBox(width: 10), Text("Deadline!")]), content: Text("${item.title} jatuh tempo sebentar lagi!"), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Tutup")), ElevatedButton(onPressed: () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (c) => DetailTodoPage(todo: item))); }, child: const Text("Lihat"))]));
  }

  void _checkDayChange() {
    if (currentUser?.targetSetDate == null) return;
    DateTime now = DateTime.now();
    DateTime lastSet = currentUser!.targetSetDate!;
    if (now.year != lastSet.year || now.month != lastSet.month || now.day != lastSet.day) {
      setState(() {
        _todoList.removeWhere((item) => !item.isRoutine);
        currentUser!.isTargetPermanent = false;
        currentUser!.targetSetDate = now;
      });
    }
  }

  void _addTodo(TodoItem item) {
    setState(() {
      _todoList.add(item);
      if (currentUser!.isTargetPermanent && !item.isRoutine && item.deadline == null) {
        item.deadline = DateTime.now();
        item.isIgnored = true;
      }
    });
  }

  void _deleteTodo(int index) {
    if (_todoList[index].isRoutine && _selectedIndex != 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kegiatan Rutin hanya bisa dihapus di halaman Jadwal!"), backgroundColor: Colors.orange)); return;
    }
    if (currentUser!.isTargetPermanent && !_todoList[index].isRoutine) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Terkunci: Tidak bisa menghapus tugas."))); return;
    }
    setState(() => _todoList.removeAt(index));
  }

  void _toggleStatus(int index, bool val) {
    if (currentUser!.isTargetPermanent && !_todoList[index].isRoutine) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Terkunci: Status tidak bisa diubah."))); return;
    }
    setState(() {
      _todoList[index].isCompleted = val;
      _todoList[index].completedAt = val ? DateTime.now() : null;
      if(val) currentUser!.totalCompleted++; else { currentUser!.totalCompleted--; currentUser!.totalUncompleted++; }
    });
  }

  void _toggleFavorite(int index) => setState(() => _todoList[index].isFavorite = !_todoList[index].isFavorite);
  void _resetList() => setState(() => _todoList.removeWhere((item) => !item.isRoutine));

  void _setTarget(int val, bool perm) {
    setState(() {
      currentUser!.dailyGoal = val;
      currentUser!.isTargetPermanent = perm;
      if (perm) {
        currentUser!.targetSetDate = DateTime.now();
        for (var item in _todoList) {
          if (!item.isRoutine && item.deadline == null && !item.isCompleted) {
            item.deadline = DateTime.now();
            item.isIgnored = true;
            currentUser!.totalIgnored++;
          }
        }
      }
    });
  }

  void _showAddOptions() {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (ctx) {
      return Padding(padding: const EdgeInsets.all(20.0), child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text("Mau buat apa?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 20),
        ListTile(leading: const CircleAvatar(backgroundColor: Colors.teal, child: Icon(Icons.repeat, color: Colors.white)), title: const Text("Kegiatan Rutin"), onTap: () { Navigator.pop(ctx); _navigateToAdd(true); }),
        const Divider(),
        ListTile(leading: const CircleAvatar(backgroundColor: AppColors.primary, child: Icon(Icons.timer, color: Colors.white)), title: const Text("Tugas Deadline"), onTap: () { Navigator.pop(ctx); _navigateToAdd(false); }),
      ]));
    });
  }

  void _navigateToAdd(bool isRoutineMode) {
    if (!isRoutineMode) {
      int count = _todoList.where((item) => !item.isRoutine).length;
      if (count >= currentUser!.dailyGoal) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Target harian tercapai!"), backgroundColor: Colors.red)); return;
      }
    }
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) => AddTodoPage(isRoutineMode: isRoutineMode),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0); var end = Offset.zero; var curve = Curves.fastOutSlowIn;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    )).then((value) { if (value != null && value is TodoItem) _addTodo(value); });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;
    String appBarTitle = "ToDoList-ByIzzu";

    List<Widget> actions = [
      IconButton(icon: const Icon(Icons.search, color: AppColors.textDark), onPressed: () => showSearch(context: context, delegate: GlobalSearchDelegate(todoList: _todoList, onNavigate: (route) {
        if (route == 'Home') setState(() => _selectedIndex = 0);
        else if (route == 'Jadwal') setState(() => _selectedIndex = 1);
        else if (route == 'Arsip') setState(() => _selectedIndex = 3);
        else if (route == 'Riwayat') setState(() => _selectedIndex = 4);
        else if (route == 'Tambah') _showAddOptions();
      })))
    ];

    switch (_selectedIndex) {
      case 0: currentScreen = DashboardView(todoList: _todoList, onDelete: _deleteTodo, onToggle: _toggleStatus, onFav: _toggleFavorite, onReset: _resetList, onSaveTarget: _setTarget, onRefresh: () => setState((){})); appBarTitle = "Dashboard"; break;
      case 1: currentScreen = ScheduleView(todoList: _todoList, onDelete: _deleteTodo); appBarTitle = "Jadwal"; break;
      case 2: currentScreen = Container(); break;
      case 3: currentScreen = ArchiveView(todoList: _todoList); appBarTitle = "Arsip"; break;
      case 4: currentScreen = HistoryView(todoList: _todoList); appBarTitle = "Riwayat"; break;
      default: currentScreen = Container();
    }

    ImageProvider? profileImage = currentUser?.imagePath != null ? FileImage(File(currentUser!.imagePath!)) : null;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(appBarTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: actions,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),

      drawer: Drawer(
        child: ListView(children: const [DrawerHeader(child: Text("Menu"))]), // Ganti dengan kode Drawer Anda
      ),

      // --- LOGIKA BODY DENGAN TUMPUKAN (STACK) ---
      body: Stack(
        children: [
          // LAYER 1: Tampilan Utama (Dashboard/Jadwal/dll)
          _selectedIndex == 2 ? const SizedBox() : currentScreen,

          // LAYER 2: Menu Pilihan (Rutin & Deadline) - Melayang di atas
          if (_isFabExpanded)
            Positioned(
              bottom: 30, // Jarak dari bawah (di atas Navbar)
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tombol Rutin
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                        child: const Text("Rutin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      const SizedBox(width: 10),
                      FloatingActionButton.small(
                        heroTag: "btnRutin",
                        onPressed: () {
                          setState(() => _isFabExpanded = false);
                          _navigateToAdd(true);
                        },
                        backgroundColor: Colors.teal,
                        child: const Icon(Icons.repeat, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Tombol Deadline
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                        child: const Text("Deadline", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                      const SizedBox(width: 10),
                      FloatingActionButton.small(
                        heroTag: "btnDeadline",
                        onPressed: () {
                          setState(() => _isFabExpanded = false);
                          _navigateToAdd(false);
                        },
                        backgroundColor: Colors.orange,
                        child: const Icon(Icons.timer, color: Colors.white),
                      ),
                    ],
                  ),

                  // Jarak kosong agar menu tidak tertutup tombol X
                  const SizedBox(height: 20),
                ],
              ),
            ),
        ],
      ),

      // --- TOMBOL UTAMA (FAB) ---
      // Hanya berisi satu tombol (X atau +) agar posisinya STABIL di dock
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 10), // Offset agar pas di lekukan
        child: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            heroTag: "btnMain",
            onPressed: () => setState(() => _isFabExpanded = !_isFabExpanded),
            backgroundColor: _isFabExpanded ? Colors.red : AppColors.primary,
            elevation: 8,
            shape: const CircleBorder(),
            child: Icon(_isFabExpanded ? Icons.close : Icons.add, color: Colors.white, size: 32),
          ),
        ),
      ),


      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            setState(() => _isFabExpanded = !_isFabExpanded);
          } else {
            setState(() {
              _selectedIndex = index;
              _isFabExpanded = false;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey.shade400,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), activeIcon: Icon(Icons.calendar_month), label: "Jadwal"),
          BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.transparent), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), activeIcon: Icon(Icons.inventory), label: "Arsip"),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: "Riwayat"),
        ],
      ),
    );
  }

  Widget _drawerChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}
