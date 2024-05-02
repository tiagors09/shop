import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/utils/environment.dart';

import '../providers/products.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    super.key,
    required this.product,
  });

  Future<void> _onPressed(BuildContext ctx) async {
    try {
      await Provider.of<Products>(
        ctx,
        listen: false,
      ).deleteProduct(
        product.id!,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          product.imageUrl,
        ),
      ),
      title: Text(product.title),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.productForm.name,
                arguments: product,
              ),
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Tem certeza?'),
                    content:
                        const Text('Tem certeza que deseja excluir produto?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _onPressed(context).catchError((e) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text(Environment.dialogTitle),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text('Fechar'),
                                  ),
                                ],
                              ),
                            );
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('Sim'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Não'),
                      )
                    ],
                  ),
                );
              },
              color: Theme.of(context).colorScheme.error,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
