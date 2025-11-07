import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firestore_service.dart';

class DashboardScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: StreamBuilder<List<Item>>(
        stream: _firestoreService.getItemsStream(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Error state
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Get items
          List<Item> items = snapshot.data ?? [];

          // Calculate statistics
          int totalItems = items.length;
          double totalValue = 0;
          int totalQuantity = 0;
          List<Item> outOfStock = [];
          List<Item> lowStock = [];

          for (Item item in items) {
            totalValue += item.quantity * item.price;
            totalQuantity += item.quantity;
            if (item.quantity == 0) {
              outOfStock.add(item);
            } else if (item.quantity < 5) {
              lowStock.add(item);
            }
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Statistics cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Items',
                        totalItems.toString(),
                        Icons.inventory_2,
                        Colors.blue,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Total Quantity',
                        totalQuantity.toString(),
                        Icons.numbers,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Value',
                        '\$${totalValue.toStringAsFixed(2)}',
                        Icons.attach_money,
                        Colors.orange,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Out of Stock',
                        outOfStock.length.toString(),
                        Icons.warning,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Out of stock items section
                if (outOfStock.isNotEmpty) ...[
                  Text(
                    'Out of Stock Items',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  ...outOfStock.map((item) => Card(
                        color: Colors.red.shade50,
                        child: ListTile(
                          leading: Icon(Icons.error, color: Colors.red),
                          title: Text(item.name),
                          subtitle: Text(item.category),
                          trailing: Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                  SizedBox(height: 24),
                ],

                // Low stock items section
                if (lowStock.isNotEmpty) ...[
                  Text(
                    'Low Stock Items (< 5)',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  ...lowStock.map((item) => Card(
                        color: Colors.orange.shade50,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Text(
                              item.quantity.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(item.name),
                          subtitle: Text(item.category),
                          trailing: Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                  SizedBox(height: 24),
                ],

                // Category breakdown
                Text(
                  'Category Breakdown',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                _buildCategoryBreakdown(items),
              ],
            ),
          );
        },
      ),
    );
  }

  // Build a statistics card
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Build category breakdown
  Widget _buildCategoryBreakdown(List<Item> items) {
    Map<String, int> categoryCount = {};

    for (Item item in items) {
      if (categoryCount.containsKey(item.category)) {
        categoryCount[item.category] = categoryCount[item.category]! + 1;
      } else {
        categoryCount[item.category] = 1;
      }
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: categoryCount.entries.map((entry) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(fontSize: 16),
                  ),
                  Chip(
                    label: Text(entry.value.toString()),
                    backgroundColor: Colors.blue.shade100,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}