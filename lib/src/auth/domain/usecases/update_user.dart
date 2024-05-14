// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/usecases/usecases.dart';
import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class UpdateUser extends UseCaseWithParams<void, UpdateUserParams> {
  const UpdateUser(this._repo);
  final AuthRepo _repo;

  @override
  ResultFuture<void> call(UpdateUserParams params) =>
      _repo.updateUser(action: params.actions, userData: params.userData);
}

class UpdateUserParams extends Equatable {
  const UpdateUserParams({
    required this.userData,
    required this.actions,
  });

  const UpdateUserParams.empty()
      : this(actions: UpdateUserActions.displayName, userData: '');

  final dynamic userData;
  final UpdateUserActions actions;

  @override
  List<Object?> get props => [userData, actions];
}
