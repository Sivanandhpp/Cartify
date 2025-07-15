import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  CategoryWidget({super.key});
  final List<Map<String, String>> categories = [
    {'name': 'All', 'icon': '🛒'},
    {'name': 'Maxxsaver', 'icon': '⬇️'},
    {'name': 'Fresh', 'icon': '🍊'},
    {'name': 'Monsoon', 'icon': '☂️'},
    {'name': 'Grocery', 'icon': '🛍️'},
    {'name': 'Beverages', 'icon': '🥤'},
    {'name': 'Home', 'icon': '🏠'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map(
              (cat) => Padding(
                padding: EdgeInsets.only(left: 10),
                child: Chip(
                  avatar: CircleAvatar(child: Text(cat['icon']!)),
                  label: Text(cat['name']!),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
