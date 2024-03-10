import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hunger_help/view/donation_page.dart';
import 'package:hunger_help/view/settings_view/profile_view.dart';

class HomePageDonor extends StatefulWidget {
  const HomePageDonor({super.key});

  @override
  State<HomePageDonor> createState() => _HomePageDonorState();
}

class _HomePageDonorState extends State<HomePageDonor> {
  int _selectedTab = 0;
  List<Widget> screens = [];
  @override
  void initState() {
    screens = [
      FutureBuilder(
          future: FirebaseDatabase.instance.ref('/restaurant').get(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snap.hasError) {
              return Center(child: Text('Error: ${snap.error}'));
            } else {
              final restaurants = snap.data!.value as Map<dynamic, dynamic>;
              return ListView.builder(
                itemCount: restaurants.entries.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurants.values.toList()[index];
                  return ListTile(
                    leading: Image.network("https://picsum.photos/200"),
                    title: Text(restaurant['name']),
                    subtitle: Text(restaurant['description']),
                    trailing: GestureDetector(
                        child: Icon(Icons.handshake),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DonationPage(data: restaurant)));
                        }),
                  );
                },
              );
            }
          }),
      FutureBuilder(
          future: FirebaseDatabase.instance.ref('/ngo').get(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snap.hasError) {
              return Center(child: Text('Error: ${snap.error}'));
            } else {
              final restaurants = snap.data!.value as Map<dynamic, dynamic>;
              return ListView.builder(
                itemCount: restaurants.entries.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurants.values.toList()[index];
                  return ListTile(
                    leading: Image.network("https://picsum.photos/200"),
                    title: Text(restaurant['name']),
                    subtitle: Text(restaurant['description']),
                    trailing: GestureDetector(
                        child: Icon(Icons.handshake),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DonationPage(data: restaurant)));
                        }),
                  );
                },
              );
            }
          }),
      SettingsPage(
        userType: "donor",
      ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: screens[_selectedTab]),
      bottomNavigationBar: DotNavigationBar(
        currentIndex: _selectedTab,
        enablePaddingAnimation: false,
        margin: const EdgeInsets.all(0),
        onTap: (val) {
          setState(() {
            _selectedTab = val;
          });
        },
        marginR: EdgeInsets.zero,
        paddingR: EdgeInsets.zero,
        items: [
          DotNavigationBarItem(
            icon: const Icon(Icons.grid_3x3),
            selectedColor: Colors.purple,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.play_arrow),
            selectedColor: Colors.orange,
          ),
          DotNavigationBarItem(
            icon: const Icon(Icons.person),
            selectedColor: Colors.red,
          ),
        ],
      ),
    );
  }
}
