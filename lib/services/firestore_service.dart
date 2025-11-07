import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class FirestoreService {
  // Create a reference to the items collection
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');

  // Add a new item to Firestore
  Future<void> addItem(Item item) async {
    await itemsCollection.add(item.toMap());
  }

  // Get a stream of all items from Firestore
  Stream<List<Item>> getItemsStream() {
    return itemsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Item.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Update an existing item
  Future<void> updateItem(Item item) async {
    if (item.id != null) {
      await itemsCollection.doc(item.id).update(item.toMap());
    }
  }

  // Delete an item
  Future<void> deleteItem(String itemId) async {
    await itemsCollection.doc(itemId).delete();
  }
}