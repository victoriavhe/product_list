import 'package:equatable/equatable.dart';
import 'package:product_list/model/product_response.dart';

abstract class ProductState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccess extends ProductState {
  final List<ProductResponse> products;

  ProductSuccess(this.products);
}

class ProductEmpty extends ProductState {
  final String message;

  ProductEmpty(this.message);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}
