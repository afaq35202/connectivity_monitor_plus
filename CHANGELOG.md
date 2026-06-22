## 1.0.0
- Updated repository and homepage URLs


## 0.1.1 - 2025-09-22
- **Platform-aware Connectivity Check**: Implemented a platform-specific strategy to check for internet connection. 
The app now uses the efficient `onConnectivityChanged` stream on mobile platforms and a more reliable periodic timer 
for the web to prevent dialog issues.


## 0.1.0 - 2025-07-29

## Added

- **Optional strict mode**: Introduced `checkActualInternet` flag to toggle between basic
  connectivity check and actual internet verification.
- **Dialog control**: Hide dialog automatically on internet back.

---

## 0.0.1

A Flutter plugin to monitor network connectivity status and listen for connectivity changes.
It provides detailed information about the current connection type (WiFi, mobile data, etc.)
and allows developers to react to network status updates in their applications.
