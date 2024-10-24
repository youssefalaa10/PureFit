import 'package:bloc/bloc.dart';
import 'package:PureFit/Features/Profile/Data/Model/user_model.dart';
import 'package:PureFit/Features/Profile/Data/Repo/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  UserModel? user;

  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> getProfile() async {
    // Avoid emitting if cubit is closed
    if (isClosed) return;

    emit(ProfileLoading());
    try {
      final fetchedUser = await profileRepo.getProfile();
      if (fetchedUser != null) {
        user = fetchedUser;
        // Check again if the cubit is closed before emitting
        if (!isClosed) {
          emit(ProfileSuccess(user: user!));
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

  Future<void> updateProfile(UserModel updatedUser, String profileId) async {
    // Avoid emitting if cubit is closed
    if (isClosed) return;

    emit(ProfileLoading());
    try {
      await profileRepo.updateProfile(updatedUser, profileId);
      user = updatedUser;

      if (!isClosed) {
        emit(ProfileSuccess(user: updatedUser));
        await getProfile(); // Optionally refresh the profile
      }
    } catch (e) {
      if (!isClosed) {
        emit(ProfileError(message: e.toString()));
      }
    }
  }
}
