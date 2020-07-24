import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_mangement/providers/products_provider.dart';
import 'package:shop_mangement/providers/purchase_provider.dart';
import 'package:shop_mangement/widgets/product_item.dart';
import 'package:shop_mangement/widgets/purchase_item.dart';

class SummaryWidget extends StatefulWidget {
  @override
  _SummaryWidgetState createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          AmountCard(),
          SomeProductCard(),
          LogCard(),
        ],
      ),
    );
  }
}

class AmountCard extends StatelessWidget {
  const AmountCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              'লেনদেন সারসংক্ষেপ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            // padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                          child: Text(
                        '230.67 Tk',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 10,
                      bottom: 10,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[300],
                                width: 2,
                              ),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '230 Taka',
                              ),
                              Icon(
                                Icons.navigate_next,
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[300],
                                width: 2,
                              ),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '230 Taka',
                              ),
                              Icon(
                                Icons.navigate_next,
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '230 Taka',
                              ),
                              Icon(
                                Icons.navigate_next,
                                color: Colors.blue,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SomeProductCard extends StatelessWidget {
  const SomeProductCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              'সর্বাধিক বিক্রিত পণ্য',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            height: 210,
            child: Consumer<ProductsProvider>(
              builder: (ctx, product, child) {
                final categoryProduct = product.items;
                return categoryProduct.length == 0
                    ? Container(
                        padding: EdgeInsets.all(20),
                        height: 200,
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/waiting.png',
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(5),
                        itemBuilder: (ctx, index) {
                          return ProductItem(
                            categoryProduct[index].id,
                          );
                        },
                        itemCount: categoryProduct.length,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LogCard extends StatelessWidget {
  const LogCard({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final purchaseData = Provider.of<PurchaseProvider>(context).items;
    return Card(
      elevation: 6,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              'সাম্প্রতিক লেনদেন',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: purchaseData.length == 0
                ? Container(
                    padding: EdgeInsets.all(20),
                    height: 200,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/waiting.png',
                    ),
                  )
                : Column(
                    children: <Widget>[
                      PurchaseItem(
                        productItem: purchaseData[0],
                      ),
                      PurchaseItem(
                        productItem: purchaseData[1],
                      ),
                      PurchaseItem(
                        productItem: purchaseData[2],
                      ),
                      PurchaseItem(
                        productItem: purchaseData[2],
                      )
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
