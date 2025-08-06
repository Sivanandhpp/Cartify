// import 'package:cartify/app/modules/buyer_panel/buyer_dashboard/views/widgets/quantity_selector_widget.dart';
// import 'package:flutter/material.dart';
// import '../../../../core/index.dart';

// /// Production-level reusable cart item card widget
// ///
// /// Displays individual cart item with image, details, quantity controls, and pricing
// class CartItemCardWidget extends StatelessWidget {
//   final CartItem item;
//   final VoidCallback? onIncrementQuantity;
//   final VoidCallback? onDecrementQuantity;

//   const CartItemCardWidget({
//     super.key,
//     required this.item,
//     this.onIncrementQuantity,
//     this.onDecrementQuantity,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8),
//             child: Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 border: Border.all(color: Colors.grey[300]!),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: item.productImage.isNotEmpty
//                   ? Image.network(item.productImage, fit: BoxFit.cover)
//                   : Icon(
//                       Icons.image_outlined,
//                       color: Colors.grey[400],
//                       size: 30,
//                     ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.productName,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 if (item.metadata['variant']?.toString().isNotEmpty == true)
//                   Text(
//                     item.metadata['variant'].toString(),
//                     style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                   ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     QuantitySelectorWidget(
//                       quantity: item.quantity,
//                       onIncrement: onIncrementQuantity,
//                       onDecrement: onDecrementQuantity,
//                     ),
//                     const Spacer(),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           '₹${item.totalPrice.toStringAsFixed(2)}',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black,
//                           ),
//                         ),
//                         if (item.hasDiscount)
//                           Text(
//                             '₹${item.price.toStringAsFixed(2)}',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                               decoration: TextDecoration.lineThrough,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
