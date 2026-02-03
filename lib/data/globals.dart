import 'package:flutter/material.dart';
import 'package:tes1/models/users_profile.dart';

class AppColors {
  static const Color primary = Color(0xFF4F46E5);
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Colors.white;
  static const Color textDark = Color(0xFF111827);
  static const Color textGrey = Color(0xFF6B7280);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentOrange = Color(0xFFF59E0B);
  static const Color accentBlue = Color(0xFF3B82F6);
}

final Map<String, Color> categoryColors = {
  'Sekolah': const Color(0xFF3B82F6),
  'Kuliah': const Color(0xFF6366F1),
  'Kerja': const Color(0xFF8B5CF6),
  'Olahraga': const Color(0xFF10B981),
  'Liburan': const Color(0xFFF59E0B),
  'Rumah': const Color(0xFFEC4899),
  'Hobi': const Color(0xFF84CC16),
  'Berpergian': const Color(0xFF06B6D4),
  'Bersih-Bersih': const Color(0xFF14B8A6),
  'Belanja': const Color(0xFFF97316),
  'Kesehatan': const Color(0xFFEF4444),
  'Lainnya': const Color(0xFF6B7280),
};

final Map<String, IconData> categoryIcons = {
  'Sekolah': Icons.school,
  'Kuliah': Icons.menu_book,
  'Kerja': Icons.work,
  'Olahraga': Icons.fitness_center,
  'Liburan': Icons.beach_access,
  'Rumah': Icons.home,
  'Hobi': Icons.palette,
  'Berpergian': Icons.flight_takeoff,
  'Bersih-Bersih': Icons.cleaning_services,
  'Belanja': Icons.shopping_cart,
  'Kesehatan': Icons.local_hospital,
  'Lainnya': Icons.more_horiz,
};

final List<Map<String, String>> countryData = [
  {'name': 'Indonesia', 'flag': '🇮🇩', 'code': '+62'},
  {'name': 'Malaysia', 'flag': '🇲🇾', 'code': '+60'},
  {'name': 'Singapore', 'flag': '🇸🇬', 'code': '+65'},
  {'name': 'USA', 'flag': '🇺🇸', 'code': '+1'},
  {'name': 'Japan', 'flag': '🇯🇵', 'code': '+81'},
  {'name': 'Arab Saudi', 'flag': '🇸🇦', 'code': '+966'},
  {'name': 'UK', 'flag': '🇬🇧', 'code': '+44'},
  {'name': 'Australia', 'flag': '🇦🇺', 'code': '+61'},
];

// Variable User Global
UserProfile? currentUser = UserProfile(
  name: "Budi",
  email: "budi@example.com",
  targetSetDate: DateTime.now(),
);