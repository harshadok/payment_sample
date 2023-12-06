import 'package:flutter/material.dart';
import 'package:razorpay_web/razorpay_web.dart';

class RezoPayIntegration extends StatefulWidget {
  const RezoPayIntegration({super.key});

  @override
  State<RezoPayIntegration> createState() => _RezoPayIntegrationState();
}

class _RezoPayIntegrationState extends State<RezoPayIntegration> {
  late Razorpay razorpay;
  @override
  void initState() {
    super.initState();
    // Initialize Razorpay instance
    razorpay = Razorpay();
    // Set up event handlers
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);
  }

  void errorHandler(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message!),
      backgroundColor: Colors.red,
    ));
  }

  void successHandler(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.paymentId!),
      backgroundColor: Colors.green,
    ));
  }

  void externalWalletHandler(ExternalWalletResponse response) {
    // Display a green-colored SnackBar with the name of the external wallet used
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.walletName!),
      backgroundColor: Colors.green,
    ));
  }

  TextEditingController amountController = TextEditingController();

  void openCheckout() {
    var options = {
      "key": "rzp_test_ZdHVfIJaSYSWCA",
      "amount": num.parse(amountController.text) * 100,
      "name": "test",
      "description": " this is the test payment",
      "timeout": "180",
      "currency": "INR",
      "prefill": {
        "contact": "11111111111",
        "email": "test@abc.com",
      }
    };
    razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Razor pay")),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: amountController,
              decoration: const InputDecoration(
                hintText: "Amount",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.0)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.0)),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.0)),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: () {
              openCheckout();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
              child: Text("Pay now"),
            ),
          ),
        ],
      )),
    );
  }
}
