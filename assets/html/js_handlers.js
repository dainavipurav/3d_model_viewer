function jsShowLoader() {
  window.flutter_inappwebview.callHandler("showLoader");
}

function jsHideLoader() {
  window.flutter_inappwebview.callHandler("hideLoader");
}

function jsSetError(error) {
  window.flutter_inappwebview.callHandler("setError", error);
}

function jsRefreshView() {
  window.flutter_inappwebview.callHandler("refreshView");
}
