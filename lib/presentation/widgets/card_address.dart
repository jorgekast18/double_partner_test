import 'package:flutter/material.dart';
import 'package:double_partner_test/domain/entities/address.dart';

class CardAddress extends StatelessWidget {
  final Address address;

  const CardAddress({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          Icons.location_on,
          color: Theme.of(context).primaryColor,
          size: 40,
        ),
        title: Text(
          address.street,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address.city,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            Text(
              address.state,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
