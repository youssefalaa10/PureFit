import 'package:PureFit/Core/Services/token_validation_service.dart';
import 'package:PureFit/Core/local_db/DioSavedToken/save_token.dart';
import 'package:bloc/bloc.dart';

part 'tokencheck_state.dart';

class TokencheckCubit extends Cubit<TokencheckState> {
  TokencheckCubit() : super(TokencheckInitial());

  Future<void> doTokenCheck() async {
    emit(TokencheckLoading());

    try {
      // Check if token exists and is valid (not expired)
      final isValid = await TokenValidationService.isTokenValid();

      if (isValid) {
        // Token is valid and not expired
        emit(TokencheckSuccessed());
      } else {
        // Token is null, empty, or expired
        await SaveTokenDB.clearToken(); // Clear expired token
        emit(TokencheckFaliuer(message: 'Token is invalid or expired'));
      }
    } catch (e) {
      // Catch any exception that might occur during the token check process
      emit(TokencheckFaliuer(message: 'Error occurred: ${e.toString()}'));
    }
  }
}
