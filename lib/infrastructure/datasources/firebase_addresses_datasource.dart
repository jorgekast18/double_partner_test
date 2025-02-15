import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/entities/address.dart';

class FirebaseAddressDatasource {
  final FirebaseFirestore _firestore;

  FirebaseAddressDatasource({
    FirebaseFirestore? firestore,
  })  : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Map<String, dynamic>> createAddress(Map<String, dynamic> address, String userId) async {
    try {
      await _firestore.collection('addresses').add({
        'userId': address['userId'],
        'street': address['street'],
        'city': address['city'],
        'state': address['state'],
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {
        ...address,
        'message': 'Dirección creada.'
      };
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<Address>> getAllAddresses(String userId) async {
    try {

      print('user id --> $userId');

      final querySnapshot = await _firestore
          .collection('addresses')
          .where('userId', isEqualTo: userId)
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
