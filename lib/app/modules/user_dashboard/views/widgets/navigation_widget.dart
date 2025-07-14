import 'package:flutter/material.dart';

class NavigationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(icon: Icon(Icons.home), onPressed: () {}),
        IconButton(icon: Icon(Icons.category), onPressed: () {}),
        IconButton(icon: Icon(Icons.replay), onPressed: () {}),
        IconButton(icon: Icon(Icons.local_offer), onPressed: () {}),
        IconButton(icon: Icon(Icons.card_giftcard), onPressed: () {}),
      ],
    );
  }
}