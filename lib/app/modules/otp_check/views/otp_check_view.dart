import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/otp_check_controller.dart';

class OtpCheckView extends GetView<OtpCheckController> {
  const OtpCheckView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OtpCheckView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OtpCheckView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
