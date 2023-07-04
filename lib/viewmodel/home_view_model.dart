import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../model/post_model.dart';
import '../services/http_service.dart';
import '../services/log_service.dart';

class HomeViewModel extends ChangeNotifier {
  bool isLoading = false;
  List<Post> items = [];

  Future apiPostList() async {
    isLoading = true;
    notifyListeners();

    var response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
    isLoading = false;
    if (response != null) {
      items = Network.parsePostList(response);
    } else {
      items = [];
    }
    notifyListeners();
  }

  Future<bool> apiPostUpdate(Post post) async {
    isLoading = true;
    notifyListeners();

    var response = await Network.PUT(
        Network.API_UPDATE + post.id.toString(), Network.paramsUpdate(post));
    isLoading = false;
    notifyListeners();
    LogService.i("Malumot yangilandi");
    return response != null;
  }

  Future<bool> apiPostDelete(Post post) async {
    isLoading = true;
    notifyListeners();

    var response = await Network.DEL(
        Network.API_DELETE + post.id.toString(), Network.paramsEmpty());
    isLoading = false;
    notifyListeners();
    return response != null;
  }

  Future<void> apiPostCreate() async {
    const url = 'http://jsonplaceholder.typicode.com/posts';

    final newData = {
      'title': 'Yangi sarlavha',
      'body': 'Yangi matn',
      'userId': 1,
    };
    isLoading = true;
    notifyListeners();

    final response = await Dio().post(url, data: newData);
    isLoading = false;
    if (response.statusCode == 201) {
      LogService.i('Malumot yaratildi');
    } else {
      LogService.e('Malumot yaratishda xatolik: ${response.statusCode}');
    }
    notifyListeners();
  }
}
