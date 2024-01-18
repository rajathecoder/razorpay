import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Razorpay_pay extends StatefulWidget {
  const Razorpay_pay({super.key});

  @override
  State<Razorpay_pay> createState() => _Razorpay_payState();
}

class _Razorpay_payState extends State<Razorpay_pay> {

  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();

  void openCheckout(amount)async{
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_Xh1GXCg9DsyKZV',
      'amount': 100,
      'name': 'Aravind',
      //'description': 'Fine T-Shirt',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try{
      _razorpay.open(options);
    }catch(e){
      debugPrint('Error : e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response){
    Fluttertoast.showToast(
        msg: "Payment Success" + response.paymentId!, toastLength : Toast.LENGTH_SHORT
    );
  }
  void handlePaymentError(PaymentFailureResponse response){
    Fluttertoast.showToast(
        msg: "Payment Fail" + response.message!, toastLength : Toast.LENGTH_SHORT
    );
  }
  void handleExternalWallet(ExternalWalletResponse response){
    Fluttertoast.showToast(
        msg: "Wallet" + response.walletName!, toastLength : Toast.LENGTH_SHORT
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text("Razorpay payment gateway"),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  cursorColor: Colors.brown,
                  autofocus: false,
                  decoration: InputDecoration(
                    labelText: 'Enter amount here',
                    enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black
                    )
                    ),
                    errorStyle: TextStyle(color: Colors.purple, fontSize: 20)
                  ),
                  controller: amtController,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter the amount';
                   }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 30,
                width: 100,
                child: ElevatedButton(
                  child: Text("pay"),
                  onPressed: (){
                    if(amtController.text.isNotEmpty){
                      setState(() {
                        int amount = int.parse(amtController.text.toString());
                        openCheckout(amount);
                      });
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
