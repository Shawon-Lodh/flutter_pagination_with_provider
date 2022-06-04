import 'package:flutter/material.dart';
import 'package:pagination_provider/APIManager.dart';

enum DataState {
  Uninitialized,
  Refreshing,
  Initial_Fetching,
  More_Fetching,
  Fetched,
  No_More_Data,
  Error
}

class ListController extends ChangeNotifier {
  int _currentPageNumber = 1;
  int _limit = 10;
  DataState _dataState = DataState.Uninitialized;

  /// if you finish pagination manually
  int _totalPages = 5;
  bool get _didLastLoad => _currentPageNumber >= _totalPages;

  /// if you finish pagination automatically
  // bool _didLastLoad = false;


  DataState get dataState => _dataState;
  List<String> _dataList = [];
  List<String> get dataList => _dataList;

  fetchData({bool isRefresh = false}) async {
    if (!isRefresh) {
      _dataState = (_dataState == DataState.Uninitialized)
          ? DataState.Initial_Fetching
          : DataState.More_Fetching;
    } else {
      _currentPageNumber = 1;
      _dataState = DataState.Refreshing;
    }
    notifyListeners();
    try {
      if (_didLastLoad) {
        _dataState = DataState.No_More_Data;
      } else {
        List<String> list = await APIManager().fetchDataFromInternet(limit: _limit, currentPage: _currentPageNumber);
        // if(list.length<_limit) _didLastLoad = true;  /// if you finish pagination automatically
        if (_dataState == DataState.Refreshing) {
          _dataList.clear();
        }
        _dataList += list;
        _dataState = DataState.Fetched;
        _currentPageNumber += 1;
      }
      notifyListeners();
    } catch (e) {
      _dataState = DataState.Error;
      notifyListeners();
    }
  }
}
