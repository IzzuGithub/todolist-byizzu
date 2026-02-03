import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../screens/detail_todo_page.dart';

class GlobalSearchDelegate extends SearchDelegate {
  final List<TodoItem>? todoList;
  final Function(String) onNavigate;
  GlobalSearchDelegate({this.todoList, required this.onNavigate});
  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));
  @override
  Widget buildResults(BuildContext context) => _buildList(context);
  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    List<TodoItem> results = [];
    if (todoList != null && query.isNotEmpty) {
      results = todoList!.where((item) => item.title.toLowerCase().contains(query.toLowerCase()) || item.description.toLowerCase().contains(query.toLowerCase()) || item.category.toLowerCase().contains(query.toLowerCase())).toList();
    }
    return ListView.builder(itemCount: results.length, itemBuilder: (context, index) => ListTile(title: Text(results[index].title), subtitle: Text(results[index].category), onTap: () { close(context, null); Navigator.push(context, MaterialPageRoute(builder: (c) => DetailTodoPage(todo: results[index]))); }));
  }
}