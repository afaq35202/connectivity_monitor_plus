import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

/// A class that monitors the internet connectivity status and notifies listeners
/// of any changes.
class ConnectivityMonitor with ChangeNotifier {
  bool _hasInternet = true;
  Timer? _timer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

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
    if (kIsWeb) {
      _startWebInternetCheck();
    } else {
      _startMobileInternetCheck();
    }
  }

  // Use a periodic timer for web as connectivity_plus stream is unreliable.
  void _startWebInternetCheck() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      final isActuallyWorking = await isInternetWorking();
      if (_hasInternet != isActuallyWorking) {
        _hasInternet = isActuallyWorking;
        notifyListeners();
      }
    });
  }

  // Use the stream listener for mobile, as it's more efficient.
  void _startMobileInternetCheck() {
    _connectivitySubscription = _connectivityManager.onConnectivityChanged.listen(_internetResult);
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
      final url = kIsWeb
          ? Uri.parse('https://one.one.one.one')
          : Uri.parse('https://www.google.com');

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } on Exception {
      return false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
