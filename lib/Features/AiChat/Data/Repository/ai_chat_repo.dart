import 'package:PureFit/Core/Networking/Dio/dio_aichat.dart';

class AiChatRepo {
  final DioChatApi dioChatApi;
  AiChatRepo({required this.dioChatApi});

  Future<String> doChatting(String message) async {
    final response = await dioChatApi.postChat(message);
    return response;
  }
}
