import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/app_routes.dart';

import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  List<Widget> drawnerItemm(
    BuildContext context,
    String title,
    IconData icon,
    Function()? onTap,
  ) {
    return [
      const Divider(),
      ListTile(
        title: Text(title),
        leading: Icon(icon),
        onTap: onTap,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text(
              'Bem vindo Usuário',
            ),
            automaticallyImplyLeading: false,
          ),
          ...drawnerItemm(
            context,
            'Loja',
            Icons.shop,
            () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.productsOverviewScreen.name,
            ),
          ),
          ...drawnerItemm(
            context,
            'Pedidos',
            Icons.payment,
            () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.orders.name,
            ),
          ),
          ...drawnerItemm(
            context,
            'Gerenciar Produtos',
            Icons.edit,
            () => Navigator.of(context).pushReplacementNamed(
              AppRoutes.products.name,
            ),
          ),
          ...drawnerItemm(
            context,
            'Sair',
            Icons.exit_to_app,
            () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.auth.name,
              );
            },
          ),
        ],
      ),
    );
  }
}
