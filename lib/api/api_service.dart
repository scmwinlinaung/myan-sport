import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<String> getWebViewUrl() async {
    try {
      final response = await _dio.get(
          'https://raw.githubusercontent.com/scmwinlinaung/myan-sport/refs/heads/main/sport_url.json');
      return response.data['url'];
    } catch (e) {
      return 'https://www.camel1.live/home';
    }
  }
}
