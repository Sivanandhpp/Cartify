import 'package:flutter/material.dart';

class HotDealsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hot deals',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All >',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDealCard('assets/images/sale1.jpg', ''),
              _buildDealCard('assets/images/sale2.jpg', ''),
              _buildDealCard('assets/images/sale3.jpg', ''),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDealCard(String imageUrl, String text) {
    return Card(
      margin: EdgeInsets.only(left: 10),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imageUrl,
                  height: 150,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          if (text.isNotEmpty) Text(text),
        ],
      ),
    );
  }
}
