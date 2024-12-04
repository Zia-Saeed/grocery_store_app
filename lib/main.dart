import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_store_app/fetch_screen.dart';
import 'package:grocery_store_app/inner_screens/cat_screen.dart';
import 'package:grocery_store_app/inner_screens/feeds_screen.dart';
import 'package:grocery_store_app/inner_screens/on_sale_screen.dart';
import 'package:grocery_store_app/inner_screens/product_details.dart';
import 'package:grocery_store_app/provider/dark_theme_provider.dart';
import 'package:grocery_store_app/providers/cart_provider.dart';
import 'package:grocery_store_app/providers/orders_provider.dart';
import 'package:grocery_store_app/providers/products_provider.dart';
import 'package:grocery_store_app/providers/viewed_prod_provider.dart';
import 'package:grocery_store_app/providers/wishlist_provider.dart';
import 'package:grocery_store_app/screens/auth/forget_pass.dart';
import 'package:grocery_store_app/screens/auth/login.dart';
import 'package:grocery_store_app/screens/auth/register.dart';
import 'package:grocery_store_app/screens/orders/orders_screen.dart';
import 'package:grocery_store_app/screens/viewed_recently/viewed_recently.dart';
import 'package:grocery_store_app/screens/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';
import 'consts/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firebaseInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text("An Error occured${snapshot.error}"),
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) {
              return themeChangeProvider;
            }),
            // applying provider class to avoid any errors
            ChangeNotifierProvider(create: (_) {
              return ProductsProvider();
            }),
            ChangeNotifierProvider(create: (_) {
              return CartProvider();
            }),
            ChangeNotifierProvider(create: (_) {
              return WishlistProvider();
            }),
            ChangeNotifierProvider(create: (_) {
              return ViewedProdProvider();
            }),
            ChangeNotifierProvider(create: (_) {
              return OrdersProvider();
            }),
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: const FetchScreen(),
                routes: {
                  OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                  FeedsScreen.routeName: (context) => const FeedsScreen(),
                  ProductDetails.routeName: (context) => const ProductDetails(),
                  WishlistScreen.routeName: (context) => const WishlistScreen(),
                  OrdersScreen.routeName: (context) => const OrdersScreen(),
                  LoginScreen.routeName: (context) => const LoginScreen(),
                  CategoryScreen.routeName: (context) => const CategoryScreen(),
                  ForgetPasswordScreen.routeName: (context) =>
                      const ForgetPasswordScreen(),
                  RegisterScreen.routeName: (context) => const RegisterScreen(),
                  ViewedRecentlyScreen.routeName: (context) =>
                      const ViewedRecentlyScreen(),
                  // WhislistScreen.routeName: (context) => const WhislistProvider(),
                },
              );
            },
          ),
        );
      },
    );
  }
}
