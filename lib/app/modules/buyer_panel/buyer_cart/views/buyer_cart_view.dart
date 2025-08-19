import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';
import '../controllers/buyer_cart_controller.dart';
import 'widgets/cart_app_bar_widget.dart';
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
      appBar: CartAppBarWidget(
        locationTitle: 'Kozhikode Work',
        storeDescription: 'Ui Technology Solutions, Ui Cyberpark, Ui Cyb...',
        onSharePressed: () {
          LogService.info('Share button pressed');
        },
        onMorePressed: () {
          LogService.info('More options pressed');
        },
      ),
      body: Obx(() {
        if (controller.isEmpty) {
          return EmptyCartWidget(
            title: 'Your cart is empty',
            subtitle: 'Add some items to get started',
            buttonText: 'Start Shopping',
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
                    Obx(
                      () => ReviewOrderSectionWidget(
                        title: 'Review your Order',
                        deliveryTime: '10 Mins',
                        deliveryType: 'Superfast',
                        cartItems: controller.cartItems,
                        itemCount: controller.itemCount,
                        onIncrementQuantity: controller.incrementQuantity,
                        onDecrementQuantity: controller.decrementQuantity,
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
                    const SizedBox(height: 100),
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
                paymentMethodTitle: 'Pay using',
                paymentMethodSubtitle: 'Wallet',
                paymentIcon: Icons.account_balance_wallet_outlined,
                paymentIconColor: Colors.blue[700],
                paymentIconBackground: Colors.blue[50],
                totalAmount: controller.finalTotal,
                buttonText: 'Pay',
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
