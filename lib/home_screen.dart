import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firestore_service.dart';
import 'add_item.dart';
import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String searchQuery = '';
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Management'),
        actions: [
          // Button to navigate to Dashboard
          IconButton(
            icon: Icon(Icons.dashboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: Text('All'),
                    selected: selectedCategory == 'All',
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = 'All';
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Electronics'),
                    selected: selectedCategory == 'Electronics',
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = 'Electronics';
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Clothing'),
                    selected: selectedCategory == 'Clothing',
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = 'Clothing';
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Food'),
                    selected: selectedCategory == 'Food',
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = 'Food';
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  FilterChip(
                    label: Text('Low Stock'),
                    selected: selectedCategory == 'Low Stock',
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = 'Low Stock';
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // List of items
          Expanded(
            child: StreamBuilder<List<Item>>(
              stream: _firestoreService.getItemsStream(),
              builder: (context, snapshot) {
                // Loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // Error state
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                // Empty state
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No items yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap + to add your first item',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                // Filter items based on search and category
                List<Item> items = snapshot.data!;
                List<Item> filteredItems = items.where((item) {
                  bool matchesSearch = item.name.toLowerCase().contains(searchQuery);
                  bool matchesCategory = selectedCategory == 'All' ||
                      item.category == selectedCategory ||
                      (selectedCategory == 'Low Stock' && item.quantity < 5);
                  return matchesSearch && matchesCategory;
                }).toList();

                // Display filtered items
                return ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    Item item = filteredItems[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: item.quantity < 5
                              ? Colors.red
                              : Colors.green,
                          child: Text(
                            item.quantity.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${item.category} • \$${item.price.toStringAsFixed(2)}',
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Navigate to edit screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddEditItemScreen(item: item),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add new item screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditItemScreen()),
          );
        },
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }
}