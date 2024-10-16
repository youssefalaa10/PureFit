import 'package:bloc/bloc.dart';
import 'package:fitpro/Core/local_db/DioSavedToken/save_token.dart';

part 'tokencheck_state.dart';

class TokencheckCubit extends Cubit<TokencheckState> {
  TokencheckCubit() : super(TokencheckInitial());

  Future<void> doTokenCheck() async {
    emit(TokencheckLoading());

    try {
      final token = await SaveTokenDB.getToken();

      if (token?.isNotEmpty ?? false) {
        // Token is valid and not empty
        emit(TokencheckSuccessed());
      } else {
        // Token is null or empty
        emit(TokencheckFaliuer(message: "Token is null or empty"));
      }
    } catch (e) {
      // Catch any exception that might occur during the token check process
      emit(TokencheckFaliuer(message: "Error occurred: ${e.toString()}"));
    }
  }
}
