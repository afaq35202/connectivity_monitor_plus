import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

/// A class that monitors the internet connectivity status and notifies listeners
/// of any changes.
class ConnectivityMonitor with ChangeNotifier {
  bool _hasInternet = true;

  /// Returns true if there is internet connectivity.
  bool get hasInternet => _hasInternet;

  /// Returns true if the internet connection is being checked.
  bool isLoading = false;

  ///main connectivity manager to listen state
  final dynamic _connectivityManager;

  ///actual internet require
  final bool checkActualInternet;

  /// Adds a listener to be notified of any changes in internet connectivity.
  ConnectivityMonitor(
    this._connectivityManager, {
    required this.checkActualInternet,
  }) {
    _checkInternet();
    _listenInternet();
  }

  void _checkInternet() {
    _connectivityManager.checkConnectivity().then(_internetResult);
  }

  void _listenInternet() {
    _connectivityManager.onConnectivityChanged.listen(_internetResult);
  }

  void _internetResult(List<ConnectivityResult> result) async {
    if (result.first == ConnectivityResult.none) {
      _hasInternet = false;
    } else {
      final isActualInternetWorking = await isInternetWorking();
      _hasInternet = isActualInternetWorking;
    }
    notifyListeners();
  }

  /// Checks if the internet connection is working.
Future<bool> isInternetWorking() async {
  try {
    if (!checkActualInternet) {
      return true;
    }
    final response = await http
        .get(Uri.parse('https://one.one.one.one'))
        .timeout(const Duration(seconds: 10));
    return response.statusCode == 200;
  } on Exception catch (_) {
    return false;
  }
}
}
