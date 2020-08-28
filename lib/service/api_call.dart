import 'package:http/http.dart' as http;
import 'package:product_list/model/product_response.dart';

const String urlBase = "https://jsonplaceholder.typicode.com/todos";

Future<http.Response> makeGetRequest(String url) async {
  var response = await http.get(url);
  return response;
}

Future<List<ProductResponse>> getProductDetail() async {
  var response = await makeGetRequest(urlBase);
  print(urlBase);
  print(response.body);

  return productResponseFromJson(response.body);
}

///ps : i used to break down services into three packages/classes for each
///one for endpoints - listing all endpoints
///one for api - handling the http call of a certain api
///one for repository - handling the api call in a simpler way to be used on bloc

///and for the http call/ headers/
///i used to put it on a class name http_helper
///and put the url base on a different class as well (i.e url_base.dart)
///so that it will be easier if we need to manage the data.

///because this is a simple app,
///i want to keep it simple, so i put it on one class instead to break it down.
///i think for this case study, this approach, will be easier to manage.