import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

enum CounterEvents {
  incrementEvent,
  dicrementEvent,
  resetEvent,
  saveEvent,
}

class CounterBloc {
   int _currentCount = 0;

   final _inputEventController = StreamController<CounterEvents>();
   StreamSink<CounterEvents> get inputEvenrSink => _inputEventController.sink;

   final _outputStateController = StreamController<int>();
    Stream<int> get outputStateStream => _outputStateController.stream;

    Future<void> _changeCounterState (CounterEvents event) async {
      if (event == CounterEvents.incrementEvent) {
        _currentCount++;
      } else if (event == CounterEvents.dicrementEvent){
        _currentCount--;
      } else if (event == CounterEvents.resetEvent){
        _currentCount = 0;
      } else if (event == CounterEvents.saveEvent) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('countValue', _currentCount);

      } else {
        throw Exception('ЧТО ТО НЕ ТО');
      }
      _outputStateController.sink.add(_currentCount);
      
    }
    
    CounterBloc(){
      _inputEventController.stream.listen(_changeCounterState);
    }
    
    Future<void> dispose() async {
      _inputEventController.close();
      _outputStateController.close();
    }
    
  }