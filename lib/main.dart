import 'package:doIt/screens/orders_screen.dart';
import 'package:flutter/material.dart';

import 'package:doIt/screens/cart_screen.dart';
import 'package:doIt/screens/product_detail_screen.dart';
import 'package:doIt/screens/products_overview_screen.dart';
import 'package:doIt/providers/products_prodivder.dart';
import 'package:provider/provider.dart';
import 'package:doIt/providers/cart.dart';
import 'package:doIt/providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
        },
      ),
    );
  }
}
