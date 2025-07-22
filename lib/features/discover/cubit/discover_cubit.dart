import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/auth/models/user_data.dart';
import 'package:social_media_app/features/discover/services/discover_services.dart';
part 'discover_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit() : super(DiscoverInitial());

  final discoverServices = DiscoverServices();

  Future<void> fetchAllUsers() async {
    try {
      emit(FetchingUsers());
      final users = await discoverServices.fetchAllUsers();
      emit(UsersFetched(users: users));
    } catch (e) {
      emit(FetchingUsersFailure(error: e.toString()));
    }
  }
}
