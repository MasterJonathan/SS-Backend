import 'package:admin_dashboard_template/widgets/common/custom_card.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      key: const PageStorageKey('productsPage'),
      child: Center(
        child: Text('Product Management Page', style: Theme.of(context).textTheme.headlineMedium),
        // Implement DataTable and CRUD for products here
      ),
    );
  }
}