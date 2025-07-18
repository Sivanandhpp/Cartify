import 'package:flutter/material.dart';
import '../../models/deal_model.dart';

class DealCardsSection extends StatelessWidget {
  final List<DealModel> deals;
  const DealCardsSection({super.key, required this.deals});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: const Color(0xFF192D8C),
        padding: const EdgeInsets.symmetric(vertical: 8),
        height: 150,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: deals.length,
          itemBuilder: (context, index) {
            final deal = deals[index];
            return Container(
              width: MediaQuery.of(context).size.width * 0.35,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: deal.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  if (deal.imageUrl != null)
                    Positioned(
                      right: -20,
                      bottom: 40,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset(deal.imageUrl!, fit: BoxFit.contain),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deal.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          deal.subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

