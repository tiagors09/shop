import 'package:flutter/material.dart';

abstract class Environment {
  static const baseUrl = String.fromEnvironment('BASE_URL');
  static const productsPath = String.fromEnvironment('PRODUCTS_PATH');
  static const ordersPath = String.fromEnvironment('ORDERS_PATH');
  static const favoriteProductsPath =
      String.fromEnvironment('FAVORITE_PRODUCTS_PATH');
  static const authBaseUrl = String.fromEnvironment('AUTH_BASE_URL');
  static const signUpUrlSegment = String.fromEnvironment('SIGN_UP_URL_SEGMENT');
  static const signInUrlSegment = String.fromEnvironment('SIGN_IN_URL_SEGMENT');
  static const webApiKey = String.fromEnvironment('WEB_API_KEY');

  static const String purchaseError =
      "Oh não! Parece que encontramos um probleminha durante a transação de compra. 🛒";
  static const String allTransactionsError =
      "Ops! Parece que algo deu errado ao recuperar todas as transações. 🐾";
  static const String updateError =
      "Oops! Parece que encontramos um probleminha ao atualizar o produto. 🙈";
  static const String insertError =
      "Ai, ai! Parece que houve um probleminha ao inserir o produto. 🐾";
  static const String deleteError =
      "Oh, não! Encontramos um probleminha ao excluir o produto. 🐶";
  static const String readError =
      "Eita! Algo deu errado ao ler o produto. Será que ele se escondeu? 🙊";
  static const String allProductsError =
      "Ops! Algo deu errado ao processar todos os produtos. 🐱";
  static const String dialogTitle = "Opsie! Probleminha";
  static const String favoritesError =
      "Ops! Algo deu errado ao recuperar os favoritos. 🌟";
  static const String toogleFavoriteError =
      "Oh, não! Encontramos um problema ao favoritar ou desfavoritar o produto dos favoritos. 💔";

  static Future<Null> showErrorMessage(
    BuildContext context,
    String content,
  ) {
    return showDialog<Null>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(Environment.dialogTitle),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
