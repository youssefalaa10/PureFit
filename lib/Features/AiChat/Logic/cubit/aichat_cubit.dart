import 'package:bloc/bloc.dart';

import 'package:PureFit/Features/AiChat/Data/Repository/ai_chat_repo.dart';

part 'aichat_state.dart';

class AichatCubit extends Cubit<AichatState> {
  final AiChatRepo aiChatRepo;
  AichatCubit(this.aiChatRepo) : super(AichatInitial());

  Future<void> doChatting(String message) async {
    emit(AichatLoading());
    try {
      final response = await aiChatRepo.doChatting(message);
      final cleanedResponse = response.replaceAll('**', '')
        ..replaceAll("##", '')
        ..replaceAll("*", '');
      emit(AichatLoaded(message: cleanedResponse));
    } on Exception catch (e) {
      emit(AichatError(message: e.toString()));
    }
  }
}
