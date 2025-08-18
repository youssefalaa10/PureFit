import 'package:PureFit/Core/local_db/DioSavedToken/save_token.dart';
import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SaveTokenDB.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Content-Type'] = 'application/json';
    super.onRequest(options, handler);
  }
}
