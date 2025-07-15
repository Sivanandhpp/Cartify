import 'package:flutter/material.dart';

class OfferWidget extends StatelessWidget {
  const OfferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              'LOWEST PRICES EVER!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'UP TO 80% OFF',
                      style: TextStyle(color: Colors.white),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('WOW DEALS'),
                    ),
                  ],
                ),
                // Column(
                //   children: [
                //     Image.asset('assets/images/sale3.jpg', height: 140,), // Placeholder for Home & Kitchen image
                //     Text('Home & kitchen', style: TextStyle(color: Colors.white)),
                //     Text('STARTING ₹35/-', style: TextStyle(color: Colors.white)),
                //   ],
                // ),
                // Column(
                //   children: [
                //     Image.asset('assets/images/sale1.jpg', height: 140,), // Placeholder for boAt image
                //     Text('boAt', style: TextStyle(color: Colors.white)),
                //     Text('UP TO 80% OFF', style: TextStyle(color: Colors.white)),
                //   ],
                // ),
                // Column(
                //   children: [
                //     Image.asset('assets/images/sale2.jpg', height: 140,), // Placeholder for Electronics image
                //     Text('Electronics & appliances', style: TextStyle(color: Colors.white)),
                //     Text('STARTING ₹99/-', style: TextStyle(color: Colors.white)),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
