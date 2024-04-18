import 'package:flutter/material.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  List<Widget> drawnerItemm(
    BuildContext context,
    String title,
    IconData icon,
    AppRoutes route,
  ) {
    return [
      const Divider(),
      ListTile(
        title: Text(title),
        leading: Icon(icon),
        onTap: () => Navigator.of(context).pushReplacementNamed(route.name),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem vindo Usuário'),
            automaticallyImplyLeading: false,
          ),
          ...drawnerItemm(
            context,
            "Loja",
            Icons.shop,
            AppRoutes.productsOverviewScreen,
          ),
          ...drawnerItemm(
            context,
            "Pedidos",
            Icons.payment,
            AppRoutes.orders,
          ),
          ...drawnerItemm(
            context,
            'Gerenciar Produtos',
            Icons.edit,
            AppRoutes.products,
          )
        ],
      ),
    );
  }
}
