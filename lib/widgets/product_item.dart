import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoutes.productDetail.name,
            arguments: product,
          );
        },
        child: GridTile(
          footer: GridTileBar(
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.black87,
            leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Image.network(
              'https://via.placeholder.com/600/92c952',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
