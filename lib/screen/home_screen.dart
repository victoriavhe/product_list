import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list/bloc/product_bloc.dart';
import 'package:product_list/bloc/product_event.dart';
import 'package:product_list/bloc/product_state.dart';
import 'package:product_list/model/product_response.dart';
import 'package:product_list/screen/checkout_screen.dart';
import 'package:product_list/widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductBloc _productBloc;
  bool isLoading = false;
  List<ProductList> productList = [];
  int _counter = 0;
  List<ProductList> chosenProductList = [];

  @override
  void initState() {
    _productBloc = ProductBloc(ProductInitial());
    _productBloc.add(FetchProductDetail());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextWidget(
          text: "Product List",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<ProductBloc, ProductState>(
          cubit: _productBloc,
          listener: (context, state) {
            if (state is ProductLoading) {
              setState(() {
                isLoading = true;
              });
            } else if (state is ProductSuccess) {
              isLoading = false;
              //didn't have to check whether it is empty-- has been checked on bloc
              for (int i = 0; i < state.products.length; i++) {
                productList.add(ProductList(state.products[i]));
              }
            }
          },
          builder: (context, state) {
            if (state is ProductEmpty) {
              return _errorWidget(state.message);
            } else if (state is ProductError) {
              return _errorWidget(state.message);
            }
            return _buildScreen();
          },
        ),
      ),
    );
  }

  Widget _buildScreen() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          strokeWidth: 2,
        ),
      );
    } else {
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: _buildList(),
          ),
          _buildButton(),
        ],
      );
    }
  }

  Widget _buildList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 3 / 4),
      itemCount: productList.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                  color: index % 2 != 0 ? Colors.white : Colors.grey),
              bottom: BorderSide(color: Colors.grey),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Center(
                child: Container(
                  height: 110,
                  width: 110,
                  child: Image(
                    fit: BoxFit.contain,
                    image: NetworkImage(
                        "https://www.freepngimg.com/thumb/tomato/6-tomato-png-image.png"),
                  ),
                ),
              ),
              TextWidget(
                text: productList[index].productResponse.title ?? "",
                fontWeight: FontWeight.bold,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                      onTap: () => _removeProduct(index),
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Colors.redAccent,
                        child: Center(
                          child: Icon(Icons.remove, color: Colors.white),
                        ),
                      )),
                  Container(
                    child: TextWidget(
                      text: '${productList[index].counter}',
                    ),
                  ),
                  InkWell(
                      onTap: () => _addProduct(index),
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Colors.redAccent,
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton() {
    return Positioned(
      bottom: 16,
      right: 16,
      left: 16,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return CheckoutScreen(
                productList: chosenProductList,
              );
            }),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Color(0xFFfb8d6e),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextWidget(text: "Qty: $_counter   "),
                ),
              ),
              VerticalDivider(
                width: 1,
                indent: 10.0,
                endIndent: 10.0,
                thickness: 0.2,
                color: Colors.black,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    ),
                    TextWidget(text: "Checkout  "),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _removeProduct(int index) {
    setState(() {
      if (productList[index].counter > 0) {
        productList[index].counter--;
        _counter -= 1;
        _addProductToList(index);
      }
    });
  }

  _addProduct(int index) {
    setState(() {
      productList[index].counter++;
      _counter += 1;
      _addProductToList(index);
    });
  }

  _addProductToList(int index) {
    //remove product if it's already on the list. save only one with the qty only.
    chosenProductList.removeWhere((element) =>
        (element.productResponse.id == productList[index].productResponse.id));
    //only add to list if the qty is more than 0
    if (productList[index].counter > 0) {
      chosenProductList.add(productList[index]);
    }
  }

  Widget _errorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextWidget(text: message),
          InkWell(
            child: TextWidget(
              text: "Try Again",
              color: Colors.blueAccent,
            ),
            onTap: () => _productBloc.add(FetchProductDetail()),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _productBloc.close();
    super.dispose();
  }
}

class ProductList {
  final ProductResponse productResponse;
  int counter = 0;

  ProductList(this.productResponse);
}
