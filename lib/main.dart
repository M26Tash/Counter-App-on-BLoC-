import 'package:bloc_counter/domain/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual, 
    overlays: [],
    );
  runApp(
    const MyApp()
    );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CounterBloc block = CounterBloc();
  
  get prefs => null;

  @override
  void dispose() {
    block.dispose();
    super.dispose();
  }

 bool _themeBool = false;

 final IconData _lightIcon = Icons.wb_sunny;
 final IconData _darkIcon = Icons.nights_stay;

 final ThemeData _lightTheme = ThemeData(
  primaryColor: const Color(0xff191A1F),
  backgroundColor: Colors.red,
  brightness: Brightness.light,
  useMaterial3: true
 );

 final ThemeData _darkTheme = ThemeData(
  primaryColor: Colors.white,
  backgroundColor:  const Color(0xff191A1F),
  brightness: Brightness.dark,
  useMaterial3: true
 );


 getCountValue() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int _currentCount = prefs.getInt('countValue') ?? 0;
  print(prefs.get('countValue'));
  return _currentCount;
}

  

bool save = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme : _themeBool ? _darkTheme : _lightTheme,
      home: Scaffold(
        backgroundColor: _themeBool ? Colors.white : const Color(0xff191A1F),
        body: SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30,),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await launchUrlString(
                        'https://instagram.com/m26_tash?igshid=YmMyMTA2M2Y='
                        );
                    }, 
                    icon: Icon(
                      Icons.info_outline_rounded,
                      color: _themeBool ?  const Color(0xff191A1F) : Colors.white,
                      ),
                      tooltip: 'Developer Info',
                    ),
                  IconButton(
                    onPressed: (){
                      setState(() {
                        _themeBool = !_themeBool;
                      });
                    }, 
                    icon: Icon(
                      _themeBool ? _darkIcon : _lightIcon,
                      color: _themeBool ?  const Color(0xff191A1F) : Colors.white,
                      ),
                    ),
                  IconButton(
                    onPressed: (){
                      block.inputEvenrSink.add(CounterEvents.resetEvent);
                    }, 
                    icon: Icon(
                      Icons.restart_alt_rounded,
                      color: _themeBool ?  const Color(0xff191A1F) : Colors.white,
                      ),
                      tooltip: 'Reset Counter',
                    ),
                  IconButton(
                    onPressed: (){
                      block.inputEvenrSink.add(CounterEvents.saveEvent);
                    }, 
                    icon: Icon(
                      Icons.save,
                      color: _themeBool ?  const Color(0xff191A1F) : Colors.white,
                      ),
                      tooltip: 'Save Counter',
                    ),
                ],
              ),
              FloatingActionButton(onPressed: (){getCountValue();}),
              const Spacer(),
              StreamBuilder(
                    stream: block.outputStateStream,
                    builder: (context , snapshot) {
                      if (snapshot.data == null) {
                        return Text(
                          '0',
                          style:  TextStyle(
                            fontSize: 160,
                            color: _themeBool ?  const Color(0xff191A1F) : Colors.white
                          ),
                          );
                      } else {
                        return Text(
                          '${snapshot.data}',
                          style: TextStyle(
                            fontSize: 160,
                            color: _themeBool ?  const Color(0xff191A1F) : Colors.white
                          ),
                        );
                      }
                    }
                  ),
                  // FloatingActionButton(onPressed: (){
                  //   getCountValue();
                  // }),
                Text(
                  'Last saved num : 0',
                  style: TextStyle(
                    color: _themeBool ?  const Color(0xff191A1F) : Colors.white,
                    fontSize: 10
                  ),
                  ),
                  const Spacer(),
              Row(
                children: [
                  Btn(
                    btnAction: (){
                      block.inputEvenrSink.add(CounterEvents.incrementEvent);
                    },
                    icon: Icons.add,
                    bgColor: _themeBool ?  Colors.grey : Colors.black,
                    iconColor: _themeBool ?  Colors.black : Colors.white,
                  ),
                  const SizedBox(width: 40,),
                  
                  const SizedBox(width: 40,),
                  Btn(
                    btnAction: (){
                      block.inputEvenrSink.add(CounterEvents.dicrementEvent);
                    },
                    icon: Icons.remove,
                    bgColor: _themeBool ?  Colors.grey : Colors.black,
                    iconColor: _themeBool ?  Colors.black : Colors.white,
                  ),

                ],
              ),
              const SizedBox(height: 40,),
            ],
          ),
        ],
      ),
    ),
      )
    );
  }
}

class Btn extends StatelessWidget {
  final IconData icon;
  final Function btnAction;
  final Color bgColor;
  final Color iconColor;
  const Btn({
    super.key,
    required this.btnAction,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: FloatingActionButton(
        isExtended: true,
        onPressed: () => btnAction(),
        backgroundColor: bgColor,
        child: Icon(
          icon,
          size: 40,
          color: iconColor,
          ),
      ),
    );
  }
}