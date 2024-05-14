import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/providers/order.dart';

class OrderWidget extends StatefulWidget {
  final Order order;

  const OrderWidget({
    super.key,
    required this.order,
  });

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final itemsHeight = (widget.order.products.length * 25) + 10;

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 300,
      ),
      height: _expanded ? itemsHeight.toDouble() + 92 : 92,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('R\$ ${widget.order.total.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.date),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() {
                  _expanded = !_expanded;
                }),
              ),
            ),
            AnimatedContainer(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: _expanded ? itemsHeight.toDouble() : 0,
              duration: const Duration(
                milliseconds: 300,
              ),
              child: ListView(
                children: widget.order.products
                    .map(
                      (product) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${product.quantity}x R\$ ${product.price}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
