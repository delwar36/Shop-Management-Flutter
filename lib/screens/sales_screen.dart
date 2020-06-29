import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/all_product_screen.dart';
import '../providers/sales_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/sale_item.dart' as si;

class SalesScreen extends StatelessWidget {
  static const routeName = '/sales';

  @override
  Widget build(BuildContext context) {
    final saleData = Provider.of<SalesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
      ),
      drawer: AppDrawer(),
      body: saleData.sales.length == 0
          ? LayoutBuilder(
              builder: (ctx, constrains) {
                return Column(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'No sales completed yet',
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
                      child: Text('Sell some now'),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
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
                );
              },
            )
          : ListView.builder(
              itemCount: saleData.sales.length,
              itemBuilder: (ctx, i) => si.SaleItem(saleData.sales[i]),
            ),
    );
  }
}
