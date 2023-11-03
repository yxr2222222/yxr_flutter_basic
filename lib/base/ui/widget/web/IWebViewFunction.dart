abstract interface class IWebViewFunction {
  Future<bool> loadUrl({required String url});

  Future<bool> canGoBack();

  Future<bool> goBack();

  Future<bool> reload();

  Future<String?> currentUrl();
}
