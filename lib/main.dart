import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/utils/custom_route.dart';
import 'package:shop/views/auth_or_home_screen.dart';
import 'package:shop/views/cart_screen.dart';
import 'package:shop/views/orders_screen.dart';
import 'package:shop/views/product_detail_screen.dart';
import 'package:shop/views/product_form_screen.dart';
import 'package:shop/views/products_overview_screen.dart';
import 'package:shop/views/products_screen.dart';

import 'providers/order.dart' show Orders;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData();

    var providers = [
      ChangeNotifierProvider(
        create: (_) => Auth(),
      ),
      ChangeNotifierProxyProvider<Auth, Products>(
        create: (BuildContext context) => Products(
          null,
          null,
          [],
        ),
        update: (ctx, auth, previousProducts) => Products(
          auth.token,
          auth.userId,
          previousProducts!.items,
        ),
      ),
      ChangeNotifierProxyProvider<Auth, Orders>(
        create: (_) => Orders(
          null,
          null,
          [],
        ),
        update: (context, auth, previousOrders) => Orders(
          auth.token,
          auth.userId,
          previousOrders!.items,
        ),
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
          AppRoutes.productsOverviewScreen.name: (ctx) =>
              const ProductsOverviewScreen(),
          AppRoutes.orders.name: (ctx) => const OrdersScreen(),
          AppRoutes.products.name: (ctx) => const ProductsScreen(),
          AppRoutes.productForm.name: (ctx) => const ProductFormScreen(),
          AppRoutes.auth.name: (ctx) => const AuthOrHomeScreen(),
        },
        initialRoute: AppRoutes.auth.name,
        title: 'Shop',
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.linux: CustomPageTransitionBuilder(),
            },
          ),
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
