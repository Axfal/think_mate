import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';

class ScreenshotProtector {
  static const platform = MethodChannel('screenshot_protection');
  static bool _isProtected = false;
  static int _protectionCount = 0;

  static Future<void> enableProtection() async {
    try {
      if (!_isProtected) {
        if (!kIsWeb && Platform.isAndroid) {
          // Try using the platform channel first
          try {
            await platform.invokeMethod('enableSecureScreen');
          } catch (e) {
            debugPrint(
                'Platform channel failed, falling back to window manager: $e');
          }

          // Use window manager as backup
          await FlutterWindowManagerPlus.addFlags(
              FlutterWindowManagerPlus.FLAG_SECURE);

          // Double apply the flag to ensure it takes effect
          await Future.delayed(Duration(milliseconds: 100));
          await FlutterWindowManagerPlus.addFlags(
              FlutterWindowManagerPlus.FLAG_SECURE);
        }
        _isProtected = true;
      }
      _protectionCount++;
      debugPrint(
          'Screenshot protection enabled successfully (count: $_protectionCount)');
    } catch (e) {
      debugPrint('Error enabling screenshot protection: $e');
      // Try to recover
      if (!kIsWeb && Platform.isAndroid) {
        try {
          await FlutterWindowManagerPlus.addFlags(
              FlutterWindowManagerPlus.FLAG_SECURE);
        } catch (retryError) {
          debugPrint('Recovery attempt failed: $retryError');
        }
      }
    }
  }

  static Future<void> disableProtection() async {
    try {
      _protectionCount--;
      if (_protectionCount <= 0) {
        if (!kIsWeb && Platform.isAndroid) {
          try {
            await platform.invokeMethod('disableSecureScreen');
          } catch (e) {
            debugPrint(
                'Platform channel failed, falling back to window manager: $e');
          }
          await FlutterWindowManagerPlus.clearFlags(
              FlutterWindowManagerPlus.FLAG_SECURE);
        }
        _isProtected = false;
        _protectionCount = 0;
        debugPrint('Screenshot protection disabled successfully');
      } else {
        debugPrint(
            'Screenshot protection still active (count: $_protectionCount)');
      }
    } catch (e) {
      debugPrint('Error disabling screenshot protection: $e');
    }
  }

  static bool get isProtected => _isProtected;

  // Force reset protection (use only when needed)
  static Future<void> forceReset() async {
    try {
      if (!kIsWeb && Platform.isAndroid) {
        await FlutterWindowManagerPlus.clearFlags(
            FlutterWindowManagerPlus.FLAG_SECURE);
        await FlutterWindowManagerPlus.clearFlags(
            FlutterWindowManagerPlus.FLAG_KEEP_SCREEN_ON);
        await FlutterWindowManagerPlus.addFlags(
            FlutterWindowManagerPlus.FLAG_SECURE);
      }
      _protectionCount = 1;
      _isProtected = true;
      debugPrint('Screenshot protection force reset successful');
    } catch (e) {
      debugPrint('Error during force reset: $e');
    }
  }
}
