import 'package:flutter/material.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/views/product_detail_screen.dart';
import 'package:shop/views/products_overview_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData();
    return MaterialApp(
      routes: {
        AppRoutes.productDetail.name: (ctx) => const ProductDetailScreen(),
      },
      title: 'Minha Loja',
      theme: ThemeData(
        colorScheme: theme.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.deepOrange,
        ),
        fontFamily: 'Lato',
      ),
      home: ProductsOverviewScreen(),
    );
  }
}
