# Inventory Management App

A simple Flutter inventory management application with Firebase Firestore backend.

## Enhanced Features Implemented

### 1. Advanced Search & Filtering
- **Real-time Search**: Search bar that filters items by name as you type
- **Category Filters**: Filter chips for different categories (Electronics, Clothing, Food, etc.)
- **Low Stock Filter**: Special filter to show items with quantity less than 5
- **Multiple Filters**: Combine search and category filters together

### 2. Data Insights Dashboard (In App Bar (Upper Right Corner))
- **Key Statistics**:
  - Total number of unique items
  - Total quantity of all items
  - Total inventory value (sum of quantity × price)
  - Count of out-of-stock items
- **Out of Stock Items**: List of items with 0 quantity
- **Low Stock Alerts**: List of items with quantity below 5
- **Category Breakdown**: Visual breakdown showing item count per category

## Features

- ✅ Create new inventory items
- ✅ View all items in real-time
- ✅ Update existing items
- ✅ Delete items with confirmation
- ✅ Search items by name
- ✅ Filter by category
- ✅ View comprehensive dashboard with statistics
- ✅ Track low stock and out-of-stock items

## Setup Instructions

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd inclass15
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project named `inventory-app-yourname`
   - Enable Firestore Database in test mode
   - Install FlutterFire CLI:
     ```bash
     dart pub global activate flutterfire_cli
     ```
   - Configure Firebase for your Flutter project:
     ```bash
     flutterfire configure
     ```
   - This will generate `firebase_options.dart` file

4. **Run the app**
   ```bash
   flutter run
   ```