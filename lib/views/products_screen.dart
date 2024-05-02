import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/product_item.dart';

import '../utils/app_routes.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  Future<void> _refreshProducts(BuildContext ctx) {
    return Provider.of<Products>(
      ctx,
      listen: false,
    ).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Produtos'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(
              AppRoutes.productForm.name,
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Consumer<Products>(
            builder: (ctx, products, _) => products.itemsCount > 0
                ? ListView.builder(
                    itemCount: products.itemsCount,
                    itemBuilder: (ctx, i) => Column(
                      children: [
                        ProductItem(
                          product: products.items[i],
                        ),
                        const Divider(),
                      ],
                    ),
                  )
                : const Center(
                    child: Text('Não há produtos para serem exibidos'),
                  ),
          ),
        ),
      ),
    );
  }
}
