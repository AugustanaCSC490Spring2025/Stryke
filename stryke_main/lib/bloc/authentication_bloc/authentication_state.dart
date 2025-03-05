part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(MyUser myUser) :
        this._(status: AuthenticationStatus.authenticated, user: myUser);

  const AuthenticationState.unauthenticated() :
        this._(status: AuthenticationStatus.unauthenticated);

  final AuthenticationStatus status;
  final MyUser? user;

  @override
  List<Object?> get props => [status, user];
}
