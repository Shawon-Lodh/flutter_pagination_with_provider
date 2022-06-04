import 'dart:async';
import 'package:dio/dio.dart';

class APIManager {
  static final APIManager _shared = APIManager._internal();
  Timer? timer;

  APIManager._internal();
  factory APIManager() {
    return _shared;
  }


  Future fetchDataByDefault({required int limit, required int currentPage}) async {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
    List<String> list = [];
    int startIndex = currentPage * 10;
    for (int i = startIndex; i < startIndex + 10; i++) {
      list.add("Item #$i");
    }
    timer!.cancel();
    return list;
  }

  Future fetchDataFromInternet({required int limit, required int currentPage}) async{
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
      try {
        Response response = await Dio().get("https://jsonplaceholder.typicode.com/todos?_limit=$limit&_page=$currentPage", queryParameters: null);
        List<String> list = [];
        response.data.forEach((element) => list.add(element["title"]));
        timer!.cancel();
        return list;
      } catch (e) {
        timer!.cancel();
        print(e.toString());
      }
  }
}
