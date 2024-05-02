import 'package:flutter/material.dart';

abstract class Environment {
  static const baseUrl = String.fromEnvironment('BASE_URL');
  static const productsPath = String.fromEnvironment('PRODUCTS_PATH');

  // Mensagens fofinhas de erro
  static const String updateError =
      "Oops! Parece que encontramos um probleminha ao atualizar o produto. 🙈";
  static const String insertError =
      "Ai, ai! Parece que houve um probleminha ao inserir o produto. 🐾";
  static const String deleteError =
      "Oh, não! Encontramos um probleminha ao excluir o produto. 🐶";
  static const String readError =
      "Eita! Algo deu errado ao ler o produto. Será que ele se escondeu? 🙊";

  // Mensagem de erro para todos os produtos
  static const String allProductsError =
      "Ops! Algo deu errado ao processar todos os produtos. 🐱";

  // Título da caixa de diálogo
  static const String dialogTitle = "Opsie! Probleminha";

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
