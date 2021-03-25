// Copyright 2021 by Fredrick Allan Grott
// BSD-style license that can be found in the LICENSE file.



import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:state_notifier/state_notifier.dart';

final Logger myCounterLogger = Logger("myCounterLogger");

abstract class CounterLogger {
  void countChanged(int count);
}

class MyState {
  MyState(this.count);
  final int count;
}

class MyStateNotifier extends StateNotifier<MyState> with LocatorMixin {
  MyStateNotifier() : super(MyState(0));

  void increment() {
    state = MyState(state.count + 1000);
  }

  @override
  @protected
  // ignore: avoid_setters_without_getters
  set state(MyState value) {
    if (state.count != value.count) {
      read<CounterLogger>().countChanged(value.count);
      myCounterLogger.info('count changed to: $value.count');
    }
    super.state = value;
  }
}
