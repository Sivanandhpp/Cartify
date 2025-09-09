import 'package:cartify/app/modules/buyer_panel/buyer_cart/views/widgets/address_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';
import '../controllers/buyer_cart_controller.dart';
import 'widgets/review_order_section_widget.dart';
import 'widgets/add_more_items_widget.dart';
import 'widgets/bill_details_widget.dart';
import 'widgets/payment_section_widget.dart';
import 'widgets/empty_cart_widget.dart';

class BuyerCartView extends GetView<BuyerCartController> {
  const BuyerCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.shoppingCartTitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isEmpty) {
          return EmptyCartWidget(
            title: AppStrings.cartEmpty,
            subtitle: AppStrings.addItemsToGetStarted,
            buttonText: AppStrings.startShopping,
            onButtonPressed: controller.addMoreItems,
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AddressSelectionWidget(),
                    const SizedBox(height: 16),

                    Obx(
                      () => ReviewOrderSectionWidget(
                        title: AppStrings.reviewYourOrder,
                        cartItems: controller.cartItems,
                        itemCount: controller.itemCount,
                        onIncrementQuantity: controller.incrementQuantity,
                        onDecrementQuantity: controller.decrementQuantity,
                        onClearCart: controller.clearCart,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AddMoreItemsWidget(
                      promptText: 'Missed Something?',
                      actionText: 'Add more items',
                      onActionPressed: controller.addMoreItems,
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => BillDetailsWidget(
                        title: 'Bill Details',
                        subtotal: controller.subtotal,
                        handlingFee: controller.handlingFee,
                        deliveryPartnerFee: controller.deliveryPartnerFee,
                        gstAmount: controller.gstAmount,
                        deliveryTip: controller.deliveryTip.value,
                        finalTotal: controller.finalTotal,
                      ),
                    ),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomSheet: Obx(
        () => controller.isEmpty
            ? const SizedBox.shrink()
            : PaymentSectionWidget(
                paymentMethodTitle: AppStrings.payUsing,
                paymentMethodSubtitle: AppStrings.wallet,
                paymentIcon: Icons.account_balance_wallet_outlined,
                paymentIconColor: Colors.blue[700],
                paymentIconBackground: Colors.blue[50],
                totalAmount: controller.finalTotal,
                buttonText: AppStrings.pay,
                isProcessing: controller.isProcessingPayment.value,
                onPaymentMethodPressed: () {
                  LogService.info('Payment method selection pressed');
                },
                onPayPressed: controller.processPayment,
              ),
      ),
    );
  }
}
