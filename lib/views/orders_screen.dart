import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_widget.dart';

import '../providers/order.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      body: Consumer<Orders>(
        builder: (ctx, orders, child) => ListView.builder(
          itemCount: orders.itemsCount,
          itemBuilder: (ctx, i) => OrderWidget(
            order: orders.items[i],
          ),
        ),
      ),
    );
  }
}
