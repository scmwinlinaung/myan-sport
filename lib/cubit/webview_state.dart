abstract class WebViewState {}

class WebViewInitial extends WebViewState {}

class WebViewLoading extends WebViewState {}

class WebViewLoaded extends WebViewState {
  final String url;
  WebViewLoaded(this.url);
}

class WebViewError extends WebViewState {
  final String message;
  WebViewError(this.message);
}
