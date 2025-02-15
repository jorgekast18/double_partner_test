import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/address.dart';

class FirebaseAddressDatasource {
  final FirebaseFirestore _firestore;

  FirebaseAddressDatasource({
    FirebaseFirestore? firestore,
  })  : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> createAddress(Address address, String userId) async {
    try {
      await _firestore.collection('addresses').add({
        'userId': address.userId,
        'street': address.street,
        'city': address.city,
        'state': address.state,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<Address>> getAllAddresses() async {
    try {

      final querySnapshot = await _firestore
          .collection('addresses')
          .get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return Address(
          id: data['id'] ?? '',
          userId: data['userId'] ?? '',
          street: data['street'] ?? '',
          city: data['city'] ?? '',
          state: data['state'] ?? '',
        );
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
