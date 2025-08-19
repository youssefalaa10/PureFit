import 'package:PureFit/Core/Networking/Dio/dio_aichat.dart';

class AiChatRepo {
  AiChatRepo({required this.dioChatApi});
  final DioChatApi dioChatApi;

  Future<String> doChatting(String message) async {
    final response = await dioChatApi.postChat(message);
    return response;
  }
}
