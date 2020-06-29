import 'package:flutter/material.dart';
import '../main.dart';
import '../providers/products_provider.dart';
import 'package:provider/provider.dart';
import '../providers/sales_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item.dart' as ci;
import 'all_product_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final cusNameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final product = Provider.of<ProductsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Bag'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\u09f3${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text('Sell Now'),
                    onPressed: (cart.items.length <= 0 || _isLoading)
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text('What is you customer name?'),
                                content: TextField(
                                  decoration: InputDecoration(
                                      labelText: 'Customer Name (Optional)'),
                                  controller: cusNameController,
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('Submit'),
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      Navigator.of(context).pop();
                                      final cusName = cusNameController.text;
                                      try {
                                        await Provider.of<SalesProvider>(
                                                context,
                                                listen: false)
                                            .addSale(
                                          cart.items.values.toList(),
                                          cart.totalAmount,
                                          'https://pngimage.net/wp-content/uploads/2018/06/logo-contact-png-2.png',
                                          cusName,
                                          DateTime.now(),
                                        );
                                        for (int i = 0;
                                            i < cart.items.length;
                                            i++) {
                                          product.decreaseById(
                                              cart.items.keys.toList()[i],
                                              cart.getQuantity(
                                                  cart.items.keys.toList()[i]));
                                        }
                                        Navigator.of(context)
                                            .pushNamed(MyHomePage.routeName);
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        cart.clear();
                                      } catch (error) {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: Text('An error occured!'),
                                            content:
                                                Text('Something went wrong'),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('Okay'),
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: cart.itemCount == 0
                ? LayoutBuilder(
                    builder: (ctx, constrains) {
                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Shopping bag is empty!',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.title,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: constrains.maxHeight * 0.5,
                                  child: Image.asset(
                                    'assets/images/waiting.png',
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                              child: Text('Add some'),
                              onPressed: () {
                                Navigator.of(ctx).pushNamed(
                                  AllProductScreen.routeName,
                                  arguments: {
                                    'title': 'All Products',
                                  },
                                );
                              },
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: cart.itemCount,
                    itemBuilder: (ctx, index) => ci.CartItem(
                      id: cart.items.values.toList()[index].id,
                      price: cart.items.values.toList()[index].price,
                      imageUrl: cart.items.values.toList()[index].productImage,
                      productId: cart.items.keys.toList()[index],
                      unit: cart.items.values.toList()[index].unit,
                      quantity: cart.items.values.toList()[index].quantiy,
                      title: cart.items.values.toList()[index].title,
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
