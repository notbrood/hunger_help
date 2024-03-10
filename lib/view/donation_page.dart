import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

class DonationPage extends StatefulWidget {
  final Map<dynamic, dynamic> data;
  const DonationPage({super.key, required this.data});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  File? _image;

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickMedia();
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      final String name = nameController.text.trim();
      final String phone = phoneController.text.trim();
      final String amount = amountController.text.trim();

      // Upload image to Firebase Storage
      String imageUrl = '';
      if (_image != null) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('payment_images')
            .child('${DateTime.now()}.jpg');
        await ref.putFile(_image!);
        imageUrl = await ref.getDownloadURL();
      }

      // Save data to Firebase Realtime Database
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref().child('payments');
      databaseReference.push().set({
        'name': name,
        'phone': phone,
        'amount': amount,
        'imageUrl': imageUrl,
        'recipient': widget.data,
      });

      // Reset form and image
      _formKey.currentState!.reset();
      setState(() {
        _image = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment submitted successfully!')));
      Navigator.pop(context);
    }
  }

  int amount = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the payment amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      amount = int.parse(amountController.text);
                    });
                  },
                  child: Text('Generate QR for this amount.'),
                ),
                SizedBox(height: 20.0),
                UPIPaymentQRCode(
                  upiDetails: UPIDetails(
                      upiID: widget.data["upiID"],
                      amount: amount.toDouble(),
                      payeeName: widget.data["name"],
                      transactionNote: "Hello World"),
                  size: 220,
                  // embeddedImagePath: 'assets/images/logo.png',
                  // embeddedImageSize: const Size(60, 60),
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.circle,
                    color: Colors.black,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.circle,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _uploadImage,
                  child: Text('Upload Image'),
                ),
                SizedBox(height: 20.0),
                _image != null
                    ? Image.file(
                        _image!,
                        height: 200,
                      )
                    : Container(),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _submitData,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
