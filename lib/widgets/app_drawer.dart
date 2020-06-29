import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/sales_screen.dart';
import '../screens/stock_screen.dart';

class AppDrawer extends StatelessWidget {
  Widget buildTile(
      String title, IconData iconData, String route, BuildContext context) {
    return ListTile(
      leading: Icon(
        iconData,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        Navigator.of(context).pushReplacementNamed(route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      child: Column(
        children: <Widget>[
          Container(
            height: 180,
            width: double.infinity,
            padding: EdgeInsets.only(left: 10, top: 40),
            alignment: Alignment.topLeft,
            color: Theme.of(context).primaryColor,
            child: Text(
              'Shop Management',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          buildTile('Home', Icons.home, MyHomePage.routeName, context),
          buildTile('Sales History', Icons.history, SalesScreen.routeName, context),
          buildTile('Stock Product', Icons.store, StockScreen.routeName, context),
        ],
      ),
    );
  }
}
