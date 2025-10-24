import 'package:PureFit/Features/AiChat/Data/Repository/ai_chat_repo.dart';
import 'package:bloc/bloc.dart';

part 'aichat_state.dart';

class AichatCubit extends Cubit<AichatState> {
  AichatCubit(this.aiChatRepo) : super(AichatInitial());
  final AiChatRepo aiChatRepo;

  Future<void> doChatting(String message) async {
    emit(AichatLoading());
    try {
      final response = await aiChatRepo.doChatting(message);
      
      // Check if response is empty or null
      if (response.isEmpty) {
        emit(AichatError(message: 'AI Coach is not responding. Please try again.'));
        return;
      }
      
      // Clean up markdown formatting
      final cleanedResponse = response
          .replaceAll('**', '')
          .replaceAll('##', '')
          .replaceAll('*', '')
          .trim();
      
      // Check if cleaned response is still empty
      if (cleanedResponse.isEmpty) {
        emit(AichatError(message: 'AI Coach response is empty. Please try again.'));
        return;
      }
      
      emit(AichatLoaded(message: cleanedResponse));
    } on Exception catch (e) {
      // Extract meaningful error message
      String errorMessage = e.toString();
      if (errorMessage.contains('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      emit(AichatError(message: errorMessage));
    } catch (e) {
      emit(AichatError(message: 'An unexpected error occurred. Please try again.'));
    }
  }
}
