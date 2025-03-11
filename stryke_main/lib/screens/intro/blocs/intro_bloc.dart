import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'intro_event.dart';
part 'intro_state.dart';

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  IntroBloc() : super(IntroInitial()) {
    on<NavigateToLogin>((event, emit) {
        emit(IntroNavigateToLogin());
    });
  }
}
