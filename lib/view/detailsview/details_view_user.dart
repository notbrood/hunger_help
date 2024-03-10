import 'package:flutter/material.dart';
import 'package:hunger_help/methods/firebase_database_services.dart';
import 'package:hunger_help/utils/constants.dart';
import 'package:hunger_help/view/homeview/home_page.dart';

class DetailsViewDonor extends StatefulWidget {
  const DetailsViewDonor({super.key});

  @override
  State<DetailsViewDonor> createState() => _DetailsViewDonorState();
}

class _DetailsViewDonorState extends State<DetailsViewDonor> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter restaurant phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process form data
                      // For now, we just print the details
                      print('Restaurant Name: ${_nameController.text}');
                      print('Description: ${_emailController.text}');
                      print('Phone Number: ${_phoneNumberController.text}');
                      FirebaseDB().createUser(Constants.donorLoginType, {
                        'name': _nameController.text,
                        'email': _emailController.text,
                        'phone': _phoneNumberController.text,
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    userType: Constants.donorLoginType,
                                  )));

                      // You can add further logic here to save the details
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
