import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_service.dart';

class OtpVerificationPage extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Verify OTP'),
        backgroundColor: Colors.yellow.shade700,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.verified, size: 100, color: Colors.yellow.shade700),
              SizedBox(height: 20),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone, color: Colors.yellow.shade700),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                  prefixIcon: Icon(Icons.lock_open, color: Colors.yellow.shade700),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (phoneController.text.isEmpty || otpController.text.isEmpty) {
                    Get.snackbar('Error', 'All fields are required',
                        backgroundColor: Colors.redAccent, colorText: Colors.white);
                    return;
                  }

                  try {
                    final response = await authService.verifyOtp(
                      phoneController.text,
                      otpController.text,
                    );

                    if (response.statusCode == 200) {
                      Get.snackbar('Success', 'OTP verified successfully',
                          backgroundColor: Colors.green, colorText: Colors.white);
                      Get.toNamed('/reset-password', arguments: {
                        'phone': phoneController.text,
                      });
                    } else {
                      final responseData = response.body != null
                          ? response.body
                          : 'Invalid OTP'; // Optionnel : décoder JSON si l'API le fournit
                      Get.snackbar('Error', responseData,
                          backgroundColor: Colors.redAccent, colorText: Colors.white);
                    }
                  } catch (e) {
                    Get.snackbar('Error', 'An error occurred: $e',
                        backgroundColor: Colors.redAccent, colorText: Colors.white);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade700,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Verify OTP',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
