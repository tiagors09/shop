import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/views/cart_screen.dart';
import 'package:shop/views/product_detail_screen.dart';

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
    ];

    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.productDetail.name: (ctx) => const ProductDetailScreen(),
          AppRoutes.cart.name: (ctx) => const CartScreen(),
        },
        initialRoute: AppRoutes.productsOverviewScreen.name,
        title: 'Minha Loja',
        theme: ThemeData(
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
        ),
      ),
    );
  }
}
