import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Data/Model/verification_model.dart';
import '../../Data/Repo/verification_repo.dart';
import 'verification_state.dart';
import 'package:flutter/material.dart';

class VerificationCubit extends Cubit<VerificationState> {
  final VerificationRepo _repo;

  VerificationCubit(this._repo) : super(VerificationInitial());

  Future<void> verifyCode(
      String email, String code, BuildContext context) async {
    emit(VerificationLoading());

    final verificationModel =
        VerificationModel(email: email, verificationCode: code);

    final response = await _repo.verifyCode(
      verificationModel.email,
      verificationModel.verificationCode,
    );

    if (response == "Verification Successful") {
      emit(VerificationSuccess(response));
    
    } else {
      emit(VerificationError(response));
    }
  }
}