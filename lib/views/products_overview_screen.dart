import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/utils/environment.dart';
import 'package:shop/widgets/app_drawer.dart';

import '../providers/cart.dart';
import '../widgets/product_grid.dart';
import '../providers/products.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _isLoading = true;
  late Products products;

  @override
  void initState() {
    super.initState();
    products = Provider.of<Products>(
      context,
      listen: false,
    );
    _onRefresh();
  }

  Future<void> _onRefresh() {
    return products
        .loadProducts()
        .then((value) => setState(
              () => _isLoading = false,
            ))
        .catchError(
      (e) {
        Environment.showErrorMessage(
          context,
          e.toString(),
        ).then(
          (_) => setState(() => _isLoading = false),
        );
      },
    );
  }

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
            initialValue: FilterOptions.all,
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.favorite) {
                products.showFavoriteOnly();
              } else if (selectedValue == FilterOptions.all) {
                products.showAll();
              }
            },
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ProductGrid(
                products: products.items,
              ),
            ),
    );
  }
}
