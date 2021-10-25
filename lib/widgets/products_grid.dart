import 'package:flutter/material.dart';
import 'package:flutter_shop_application/providers/product.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  final String keywords;

  ProductsGrid({required this.showFavs, required this.keywords});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    // ignore: unnecessary_null_comparison
    final List<Product>? searchProducts = keywords == null
        ? null
        : Provider.of<Products>(context).searchProducts(keywords);
    bool searchCheck = searchProducts != null ? true : false;
    // ignore: unnecessary_null_comparison

    final products = searchCheck
        ? searchProducts
        : showFavs
            ? productsData.itemsFavorites
            : productsData.items;
    return products.isEmpty
        ? Center(
            child: Text(
              'No have any item!',
              style: TextStyle(color: Colors.grey),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 20),
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: ProductItem(),
            ),
            itemCount: products.length,
          );
  }
}
