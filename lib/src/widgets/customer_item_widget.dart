import 'package:flutter/material.dart';
import '../models/customer.dart';

class CustomerItemWidget extends StatelessWidget {
  final Customer customer;
  final bool canNavigate;

  const CustomerItemWidget({
    Key? key,
    required this.customer,
    this.canNavigate = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          customer.fullName(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          customer.mobile ?? customer.tel ?? 'No contact info',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        trailing: canNavigate
            ? const Icon(Icons.arrow_forward)
            : null,
        onTap: canNavigate
            ? () {
          Navigator.pushNamed(
            context,
            '/customerDetails',
            arguments: customer,
          );
        }
            : null,
      ),
    );
  }
}
