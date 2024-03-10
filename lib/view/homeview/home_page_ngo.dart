import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hunger_help/utils/util_functions.dart';
import 'package:hunger_help/view/settings_view/profile_view.dart';
import 'package:hunger_help/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePageNGO extends StatefulWidget {
  const HomePageNGO({super.key});

  @override
  State<HomePageNGO> createState() => _HomePageNGOState();
}

class _HomePageNGOState extends State<HomePageNGO> {
  int _selectedTab = 0;
  List<Widget> screens = [];
  @override
  void initState() {
    screens = [
      PostWidget(),
      FoodListingPage(),
      const Text("Order book"),
      SettingsPage(
        userType: "ngo",
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
            icon: const Icon(Icons.book),
            selectedColor: Colors.teal,
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

class PostWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 5, // Number of posts
        itemBuilder: (context, index) {
          return PostItem(
            username: 'user_$index',
            imageUrl: 'https://picsum.photos/200', // Sample image URL
            likes: 20 + index, // Sample likes count
            comments: 5 + index, // Sample comments count
          );
        },
      ),
    );
  }
}

class PostItem extends StatelessWidget {
  final String username;
  final String imageUrl;
  final int likes;
  final int comments;

  PostItem({
    required this.username,
    required this.imageUrl,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(username[0]),
                ),
                SizedBox(width: 10.0),
                Text(username),
              ],
            ),
          ),
          Image.network(
            imageUrl,
            width: double.infinity,
            height: 300.0,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    // Handle like button
                  },
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    // Handle comment button
                  },
                ),
                SizedBox(width: 10.0),
                Text('$likes likes, $comments comments'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FoodListingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Listing'),
      ),
      body: FoodListingWidget(),
    );
  }
}

class FoodListingWidget extends StatefulWidget {
  @override
  State<FoodListingWidget> createState() => _FoodListingWidgetState();
}

class _FoodListingWidgetState extends State<FoodListingWidget> {
  bool iconChane = false;

  @override
  Widget build(BuildContext context) {
    // Sample food items data
    List<FoodItem> foodItems = [
      FoodItem(
          name: 'Burger',
          description: 'Delicious burger with fries',
          price: '\$5.99'),
      FoodItem(
          name: 'Pizza',
          description: 'Italian pizza with assorted toppings',
          price: '\$8.99'),
      FoodItem(
          name: 'Pasta',
          description: 'Spaghetti with tomato sauce',
          price: '\$6.99'),
    ];

    return ListView.builder(
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network("https://picsum.photos/200"),
          title: Text(foodItems[index].name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(foodItems[index].description),
              Text('Quantity: 10'),
              Text("Listed Time: 10:00 AM")
            ],
          ),
          trailing: IconButton(
            icon: Icon(
                iconChane == true ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                iconChane = !iconChane;
              });
              if (iconChane == true) {
                UtilFunctions().showSnackbar(context,
                    "The restaurant has been notified, they will be contacting you soon");
              }
            },
          ),
        );
      },
    );
  }
}

class FoodItem {
  final String name;
  final String description;
  final String price;

  FoodItem({
    required this.name,
    required this.description,
    required this.price,
  });
}
