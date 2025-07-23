// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../controllers/product_sheet_controller.dart';

// class ProductSheetHeader extends StatelessWidget {
//   final ProductSheetController controller;

//   const ProductSheetHeader({super.key, required this.controller});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => controller.isAppBarVisible.value
//           ? SliverToBoxAdapter(
//               child: Container(
//                 height: 60,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Colors.black.withOpacity(0.95),
//                       Colors.black.withOpacity(0.1),
//                     ],
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Row(
//                     children: [
//                       _buildCloseButton(),
//                       Expanded(
//                         child: Text(
//                           controller.productName.value,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                           textAlign: TextAlign.center,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       _buildWishlistButton(),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           : const SliverToBoxAdapter(child: SizedBox.shrink()),
//     );
//   }

//   Widget _buildCloseButton() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: IconButton(
//         onPressed: controller.closeSheet,
//         icon: const Icon(
//           Icons.keyboard_arrow_down,
//           color: Colors.black87,
//           size: 24,
//         ),
//         padding: const EdgeInsets.all(8),
//         constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
//       ),
//     );
//   }

//   Widget _buildWishlistButton() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.red.shade50,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: IconButton(
//         onPressed: controller.addToWishlist,
//         icon: Icon(Icons.favorite_border, color: Colors.red.shade400, size: 20),
//         padding: const EdgeInsets.all(8),
//         constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
//       ),
//     );
//   }
// }
