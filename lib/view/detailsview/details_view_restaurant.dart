import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hunger_help/methods/firebase_database_services.dart';
import 'package:hunger_help/utils/constants.dart';
import 'package:hunger_help/view/homeview/home_page.dart';

class DetailsViewRestaurant extends StatefulWidget {
  const DetailsViewRestaurant({super.key});

  @override
  State<DetailsViewRestaurant> createState() => _DetailsViewRestaurantState();
}

class _DetailsViewRestaurantState extends State<DetailsViewRestaurant> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _upiIDController = TextEditingController();
  final TextEditingController _restaurantHeadName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _restaurantHeadName,
                  decoration: const InputDecoration(
                    labelText: 'Restaurant owner name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter restaurant owner name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Restaurant Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter restaurant name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter restaurant description';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText:
                        'Location (Consider putting in google maps link!)',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter restaurant location';
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
                TextFormField(
                  controller: _upiIDController,
                  decoration: const InputDecoration(
                    labelText: 'UPI ID',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter restaurant UPI ID';
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
                        print('Description: ${_descriptionController.text}');
                        print('Location: ${_addressController.text}');
                        print('Phone Number: ${_phoneNumberController.text}');
                        print('Phone Number: ${_upiIDController.text}');
                        FirebaseDB().createUser(Constants.restaurantLoginType, {
                          'name': _nameController.text,
                          'description': _descriptionController.text,
                          'location': _addressController.text,
                          'phone': _phoneNumberController.text,
                          'upiID': _upiIDController.text,
                          'restaurantOwnerName': _restaurantHeadName.text,
                          'status': Constants.awaitingApproval
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      userType: Constants.restaurantLoginType,
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
      ),
    );
  }
}
