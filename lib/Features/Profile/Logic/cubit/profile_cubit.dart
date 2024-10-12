import 'package:bloc/bloc.dart';
import 'package:fitpro/Features/Profile/Data/Model/user_model.dart';
import 'package:fitpro/Features/Profile/Data/Repo/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit(this.profileRepo) : super(ProfileInitial());
  UserModel? user;
  getProfile() async {
    emit(ProfileLoading());
    try {
      final user = await profileRepo.getProfile();
      if (user != null) {
        if (!isClosed) {
          emit(ProfileSuccess(user: user));
          this.user = user;
        }
      } else {
        if (!isClosed) {
          emit(ProfileError(message: 'Failed to fetch profile'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(ProfileError(message: e.toString()));
      }
    }
  }

  void updateProfile(UserModel user, String profileId) async {
    emit(ProfileUpdating());
    try {
      final success = await profileRepo.updateProfile(user, profileId);
      if (success) {
        if (!isClosed) {
          emit(ProfileUpdated());
        }
      } else {
        if (!isClosed) {
          emit(ProfileError(message: 'Failed to update profile'));
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(ProfileError(message: e.toString()));
      }
    }
  }
}
