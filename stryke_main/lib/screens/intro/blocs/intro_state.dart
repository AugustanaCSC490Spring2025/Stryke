part of 'intro_bloc.dart';

@immutable
sealed class IntroState {}

final class IntroInitial extends IntroState {}

class IntroNavigateToLogin extends IntroState {}
