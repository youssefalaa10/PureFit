import 'package:PureFit/Core/Networking/ErrorHandler/api_error_model.dart';
import 'package:dio/dio.dart';

class ApiErrorHandler {
  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.badResponse:
          return ApiErrorModel(message: error.response?.data['message']);
        case DioExceptionType.connectionTimeout:
          return ApiErrorModel(message: "Connection timeout");
        case DioExceptionType.sendTimeout:
          return ApiErrorModel(message: "Send timeout");
        case DioExceptionType.receiveTimeout:
          return ApiErrorModel(message: "Receive timeout");
        case DioExceptionType.cancel:
          return ApiErrorModel(message: "Request canceled");
        case DioExceptionType.connectionError:
          return ApiErrorModel(message: "Connection error");
        case DioExceptionType.unknown:
          return ApiErrorModel(message: "Unknown error");
        default:
          return ApiErrorModel(message: "Something went wrong");
      }
    } else {
      return ApiErrorModel(
        message: "Unknown error occurred",
      );
    }
  }
}
