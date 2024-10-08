import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print("Block creat");
  }

  // @override
  // void onEvent(Bloc bloc, Object event){
  //   super.onEvent(bloc, event);
  //   print(event);
  // }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print("BLoc close");
  }
}
