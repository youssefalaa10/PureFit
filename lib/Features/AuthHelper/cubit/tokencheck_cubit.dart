import 'package:bloc/bloc.dart';
import 'package:fitpro/Core/LocalDB/DioSavedToken/save_token.dart';

part 'tokencheck_state.dart';

class TokencheckCubit extends Cubit<TokencheckState> {
  TokencheckCubit() : super(TokencheckInitial());

  doTokenCheck() async {
    emit(TokencheckLoading());
    String? token = await SaveTokenDB.getToken();
    try {
      if (token != null || token!.isNotEmpty) {
        emit(TokencheckSuccessed());
      }
    } on Exception catch (e) {
      emit(TokencheckFaliuer(message: e.toString()));
    }
  }
}
