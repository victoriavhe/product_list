import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list/bloc/product_event.dart';
import 'package:product_list/bloc/product_state.dart';
import 'package:product_list/model/product_response.dart';
import 'package:product_list/service/api_call.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(ProductState initialState) : super(initialState);

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is FetchProductDetail) {
      yield ProductLoading();
      try {
        List<ProductResponse> response = await getProductDetail();

        if (response.isNotEmpty) {
          yield ProductSuccess(response);
        } else {
          yield ProductEmpty("Product list is empty.");
        }
      } on Exception catch (e) {
        yield ProductError(e.toString());
      }
    }
  }
}
