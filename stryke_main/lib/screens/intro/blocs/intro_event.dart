part of 'intro_bloc.dart';

@immutable
sealed class IntroEvent {}

class NavigateToLogin extends IntroEvent {}
