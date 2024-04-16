import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/views/cart_screen.dart';
import 'package:shop/views/orders_screen.dart';
import 'package:shop/views/product_detail_screen.dart';
import 'package:shop/views/products_overview_screen.dart';

import 'providers/order.dart' show Orders;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData();

    var providers = [
      ChangeNotifierProvider(
        create: (_) => Products(),
      ),
      ChangeNotifierProvider(
        create: (_) => Cart(),
      ),
      ChangeNotifierProvider(
        create: (_) => Orders(),
      ),
    ];

    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.productDetail.name: (ctx) => const ProductDetailScreen(),
          AppRoutes.cart.name: (ctx) => const CartScreen(),
          AppRoutes.productsOverviewScreen.name: (ctx) =>
              const ProductsOverviewScreen(),
          AppRoutes.orders.name: (ctx) => const OrdersScreen(),
        },
        initialRoute: AppRoutes.productsOverviewScreen.name,
        title: 'Minha Loja',
        theme: ThemeData(
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
            error: Colors.red,
          ),
          fontFamily: 'Lato',
        ),
      ),
    );
  }
}
