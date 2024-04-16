import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/widgets/app_drawer.dart';

import '../providers/cart.dart';
import '../widgets/product_grid.dart';
import '../providers/products.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Products products = Provider.of(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          Consumer<Cart>(
            child: IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.cart.name,
              ),
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (ctx, cart, child) => Badge(
              label: Text(cart.itemsCount.toString()),
              child: child,
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) =>
                selectedValue == FilterOptions.favorite
                    ? products.showFavoriteOnly()
                    : products.showAll(),
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text('Somente Favoritos'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Todos'),
              ),
            ],
          ),
        ],
      ),
      body: const ProductGrid(),
    );
  }
}
