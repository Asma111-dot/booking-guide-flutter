import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final List<int> savedItems; // تمرير العناصر المحفوظة إلى الصفحة

  const FavoritesPage({Key? key, required this.savedItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المفضلة'),
      ),
      body: savedItems.isEmpty
          ? Center(child: Text('لا توجد عناصر محفوظة'))
          : ListView.builder(
        itemCount: savedItems.length,
        itemBuilder: (context, index) {
          final itemId = savedItems[index];
          return ListTile(
            title: Text('العنصر المحفوظ $itemId'), // قم بتغيير هذا حسب العنصر الفعلي
          );
        },
      ),
    );
  }
}
