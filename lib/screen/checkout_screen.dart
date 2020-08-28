import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:product_list/screen/home_screen.dart';
import 'package:product_list/widgets/text_widget.dart';

import 'home_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<ProductList> productList;

  const CheckoutScreen({Key key, this.productList}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isEmptyCart = true;

  @override
  void initState() {
    isEmptyCart = widget.productList.isEmpty || widget.productList.length == 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: TextWidget(
          text: "Checkout",
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Stack(
          children: <Widget>[
            !isEmptyCart
                ? buildProductList()
                : Center(
                    child: TextWidget(
                      text: "Empty Cart",
                    ),
                  ),
            Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: InkWell(
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false,
                ),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Color(0xFFfb8d6e),
                  ),
                  child: Center(
                    child: TextWidget(
                        text: !isEmptyCart ? "Buy Now" : "Discover Product"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildProductList() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(
                  text: widget.productList[index].productResponse.title,
                ),
                TextWidget(
                  text: widget.productList[index].counter.toString(),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1,
          );
        },
        itemCount: widget.productList.length);
  }
}
