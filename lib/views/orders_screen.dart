import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/environment.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_widget.dart';

import '../providers/order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  Future<void> _onRefresh() {
    return Provider.of<Orders>(
      context,
      listen: false,
    )
        .loadOrders()
        .then(
          (_) => setState(
            () {
              _isLoading = false;
            },
          ),
        )
        .catchError(
      (e) {
        Environment.showErrorMessage(
          context,
          e.toString(),
        );
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Orders>(
              builder: (ctx, orders, child) => orders.itemsCount > 0
                  ? RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        itemCount: orders.itemsCount,
                        itemBuilder: (ctx, i) => OrderWidget(
                          order: orders.items[i],
                        ),
                      ),
                    )
                  : const Center(
                      child: Text('Não há pedidos'),
                    ),
            ),
    );
  }
}
