import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/environment.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  bool _isLoading = false;

  void _updateImageUrl() {
    if (_isValidImageUrl(
      _imageUrlController.text,
    )) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final product = ModalRoute.of(context)?.settings.arguments;

    if (_formData.isEmpty && product != null) {
      product as Product;
      _formData['id'] = product.id;
      _formData['title'] = product.title;
      _formData['description'] = product.description;
      _formData['price'] = product.price;
      _formData['imageUrl'] = product.imageUrl;

      _imageUrlController.text = _formData['imageUrl'];
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
  }

  String? _priceValidator(value) {
    bool isEmpty = value!.trim().isEmpty;
    var newPrice = double.tryParse(value);
    bool isInvalid = newPrice == null || newPrice <= 0;

    if (isEmpty || isInvalid) {
      return 'Informe um Preço válido';
    }

    return null;
  }

  String? _titleValidator(String? value) {
    if (value!.trim().isEmpty) {
      return 'Informe um título válido!';
    }

    if (value.trim().length < 3) {
      return 'Informe um título com no mínimo 3 letras!';
    }

    return null;
  }

  String? _descriptionValidator(String? value) {
    if (value!.trim().isEmpty) {
      return 'Informe um título válido!';
    }

    if (value.trim().length < 10) {
      return 'Informe um título com no mínimo 10 letras!';
    }

    return null;
  }

  String? _imageUrlValidator(String? value) {
    bool isEmpty = value!.trim().isEmpty;
    bool isInvalid = !_isValidImageUrl(value);

    if (isEmpty || isInvalid) {
      return 'Informe uma URL válida!';
    }

    return null;
  }

  bool _isValidImageUrl(String url) {
    bool startWithHttp = url.toLowerCase().startsWith('http://');
    bool startWithHttps = url.toLowerCase().startsWith('https://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');

    return (startWithHttp || startWithHttps) &&
        (endsWithPng || endsWithJpg || endsWithJpeg);
  }

  Future<void> _saveForm() async {
    bool isValid = _form.currentState!.validate();

    if (!isValid) return;

    _form.currentState!.save();

    final newProduct = Product(
      id: _formData['id'],
      title: _formData['title'],
      description: _formData['description'],
      price: _formData['price'],
      imageUrl: _formData['imageUrl'],
    );

    setState(() {
      _isLoading = true;
    });

    final products = Provider.of<Products>(
      context,
      listen: false,
    );

    Future<void> Function(Product) operation;

    if (_formData['id'] == null) {
      operation = products.addProduct;
    } else {
      operation = products.updateProduct;
    }

    operation(newProduct).then(
      (_) {
        Navigator.of(context).pop();
        setState(() {
          _isLoading = false;
        });
      },
    ).catchError(
      (e) => Environment.showErrorMessage(
        context,
        e.toString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário Produto'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['title'],
                      validator: _titleValidator,
                      onSaved: (value) => _formData['title'] = value!,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price'] == null
                          ? ''
                          : _formData['price'].toString(),
                      validator: _priceValidator,
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value!),
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(
                        _descriptionFocusNode,
                      ),
                      focusNode: _priceFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Preço',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    TextFormField(
                      initialValue: _formData['description'],
                      validator: _descriptionValidator,
                      onSaved: (value) => _formData['description'] = value!,
                      focusNode: _descriptionFocusNode,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                      ),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            onSaved: (value) => _formData['imageUrl'] = value!,
                            controller: _imageUrlController,
                            decoration: const InputDecoration(
                              labelText: 'URL da Imagem',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            validator: _imageUrlValidator,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                            top: 8,
                          ),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Informe a URL')
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
