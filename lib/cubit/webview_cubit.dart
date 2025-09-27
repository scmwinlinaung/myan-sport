import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myan_sport/api/api_service.dart';
import 'package:myan_sport/cubit/webview_state.dart';

class WebViewCubit extends Cubit<WebViewState> {
  final ApiService _apiService;

  WebViewCubit(this._apiService) : super(WebViewInitial());

  Future<void> fetchWebViewUrl() async {
    try {
      emit(WebViewLoading());
      final url = await _apiService.getWebViewUrl();
      emit(WebViewLoaded(url));
    } catch (e) {
      emit(WebViewError('Failed to fetch URL'));
    }
  }
}
