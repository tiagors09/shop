import 'package:flutter/material.dart';

import '../providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 15,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Text(
                  'R\$ ${cartItem.price.toStringAsFixed(2)}',
                ),
              ),
            ),
          ),
          title: Text(cartItem.title.toString()),
          subtitle: Text(
            'Total: R\$ ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
          ),
          trailing: Text(
            '${cartItem.quantity}x',
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
