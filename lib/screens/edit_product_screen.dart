import '../providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  // final _priceFocusNode = FocusNode();
  // final _descriptionFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValue = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          // "imageUrl": _editedProduct.imageUrl
          'imageUrl': ''
        };
        _imageURLController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageURLController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
  }

  void _updateImageUrl() {
    if ((!_imageUrlFocusNode.hasFocus) &&
        (!_imageURLController.text.startsWith('http') &&
                !_imageURLController.text.startsWith('https') ||
            !_imageURLController.text.endsWith('.png') &&
                !_imageURLController.text.endsWith(".jpg") &&
                !_imageURLController.text.endsWith('.jpeg'))) return;
    setState(() {});
  }

  Future<void> _saveForm() async {
    if (!_form.currentState.validate()) return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("An error occured!"),
            content: Text('Something went wrong.'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Okay'),
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValue['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) return 'Please provide a value';
                        return null;
                      },
                      onSaved: (newValue) => _editedProduct = Product(
                        title: newValue,
                        price: _editedProduct.price,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                      ),
                      // onFieldSubmitted: (_) {
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                    ),
                    TextFormField(
                      initialValue: _initValue['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      onSaved: (newValue) => _editedProduct = Product(
                        title: _editedProduct.title,
                        price: double.parse(newValue),
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                      ),
                      // focusNode: _priceFocusNode,
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter a price';
                        if (double.tryParse(value) == null)
                          return 'Please enter valide number';
                        if (double.parse(value) <= 0)
                          return 'Please enter a number greater then zero.';
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onSaved: (newValue) => _editedProduct = Product(
                        title: _editedProduct.title,
                        price: _editedProduct.price,
                        description: newValue,
                        imageUrl: _editedProduct.imageUrl,
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                      ),
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter a description';
                        if (value.length < 10)
                          return 'Should be at least 10 characters long';
                        return null;
                      },
                      // focusNode: _descriptionFocusNode,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageURLController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageURLController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageURLController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            onSaved: (newValue) => _editedProduct = Product(
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              description: _editedProduct.description,
                              imageUrl: newValue,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                            ),
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Please enter a image URL.';
                              if (!value.startsWith('http') ||
                                  !value.startsWith('https'))
                                return 'Please enter a valid URL.';
                              if (!value.endsWith('.png') &&
                                  !value.endsWith(".jpg") &&
                                  !value.endsWith('.jpeg'))
                                return 'Please enter a valid URL.';
                              return null;
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
