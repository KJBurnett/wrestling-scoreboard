import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Wrestling Scoreboard')),
        body: TimerPage(),
      ),
    );
  }
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late Timer _timer;
  int _counter = 420; // 7 minutes in seconds
  bool isCountingDown = false;
  int _blueCounter = 0;
  int _redCounter = 0;
  int _ridingTime = 0;
  bool _isRidingTimeCountingDown = false;
  bool _countRidingTime = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration.zero, () {});
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String formatRidingTime(int seconds) {
    int absoluteSeconds = seconds.abs();
    int minutes = absoluteSeconds ~/ 60;
    int remainingSeconds = absoluteSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  //function to adjust time
  void _adjustTimer(int seconds) {
  setState(() {
    _counter = (_counter + seconds).clamp(0, 420); // Ensure the timer doesn't go below 0 or above 7 minutes
  });
}

  // String state can be "clock" or "riding"
  void runClock(String state) {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_counter == 0 && isCountingDown) {
            _isRidingTimeCountingDown = false;
            _countRidingTime = false;
            timer.cancel();
          } else {
            if (isCountingDown) {
              _counter--;
              if (_countRidingTime) {
                // If _countRidingTime is true, then we need to be incrementing riding time as well along with the clock.
                if (_isRidingTimeCountingDown) {
                  _ridingTime--;
                } else {
                  _ridingTime++;
                }
              }
            }
            if (!isCountingDown) {
              _isRidingTimeCountingDown = false; // Ensure Riding Time stops.
              _countRidingTime = false;
              timer.cancel();
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Position the "clock" 3/4 up the app centered
          Positioned(
            top: MediaQuery.of(context).size.height / 40,
            left: MediaQuery.of(context).size.width / 2.3,
            child: Center(
              child: Text(
                formatTime(_counter),
                style: TextStyle(
                  fontSize: 200.0,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          // Position the buttons at the bottom center of the app
          Positioned(
            top: 5,
            left: MediaQuery.of(context).size.width / 40,
            
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    isCountingDown = isCountingDown ? false : true;
                    runClock("clock");
                  },
                  child: Text('Play/Pause Clock'),
                ),
                SizedBox(width: 10), // Add some spacing between the buttons
                ElevatedButton(
                  onPressed: () {
                    isCountingDown = false;
                    _counter = 420; // 7 minutes
                    runClock("clock");
                  },
                  child: Text('Reset Clock'),
                ),
                 ElevatedButton(
                  onPressed: () {
                     if (!isCountingDown) {
                    setState(() {
                      _adjustTimer(-60); // Subtract 1 minute
                       });
                    }
                },
              child: Text('-1 min'),
              
                ),
                
                SizedBox(width: 10), // Add spacing between buttons
                ElevatedButton(
                  onPressed: () {
                    if (!isCountingDown) {
                    setState(() {
                      _adjustTimer(-1); // Subtract 1 second
                       });
                    }
                 },
                child: Text('-1 sec'),
                ),
                SizedBox(width: 10), // Add spacing between buttons
                ElevatedButton(
                  onPressed: () {
                     if (!isCountingDown) {
                    setState(() {
                      _adjustTimer(1); // add 1 second
                       });
                    }
                   },
                 child: Text('+1 sec'),
                ),
                
                SizedBox(width: 10), // Add spacing between buttons
                ElevatedButton(
                  onPressed: () {
                     if (!isCountingDown) {
                    setState(() {
                      _adjustTimer(60); // add 1 minute
                       });
                    }
                  },
                child: Text('+1 min'),
                    ), 
                    ElevatedButton(
                      onPressed: () {
                        if (!isCountingDown) {
                          setState(() {
                            _blueCounter = 0; // clear both scores
                            _redCounter = 0;
                       });
                    }
                },
              child: Text('Clear Score'),
                ),
                    ],
                  ),
                ),
          // Position the "Riding Time" Text below the main clock
          Positioned(
            top: MediaQuery.of(context).size.height / 4,
            left: MediaQuery.of(context).size.width / 2.09,
            child: Column(
              children: <Widget>[
                Text(
                  'Riding Time',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Position the "Riding Time" clock below the main clock
          Positioned(
            top: MediaQuery.of(context).size.height / 4,
            left: MediaQuery.of(context).size.width / 2.3,
            child: Column(
              children: <Widget>[
                Text(
                  formatRidingTime(_ridingTime),
                  style: TextStyle(
                    fontSize: 100.0,
                    color: _ridingTime < 0
                        ? Colors.green
                        : (_ridingTime > 0 ? Colors.red : Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isRidingTimeCountingDown = true;
                          _countRidingTime = true;
                          if (_ridingTime > 0) {
                            _ridingTime--;
                          }
                        });
                      },
                      child: Text('Riding Time Green'),
                    ),
                    SizedBox(width: 10), // Add some spacing between the buttons
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isRidingTimeCountingDown = false;
                          _ridingTime++;
                          _countRidingTime = true;
                        });
                      },
                      child: Text('Riding Time Red'),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _ridingTime = 0;
                          _countRidingTime = false;
                        });
                      },
                      child: Text('Reset Riding Time'),
                    ),
                    SizedBox(width: 10), // Add some spacing between the buttons
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _countRidingTime = false;
                        });
                      },
                      child: Text('Pause Riding Time'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Draw a white line horizontally in the middle of the app
          Positioned(
            top: MediaQuery.of(context).size.height / 1.8,
            child: Container(
              height: 1.0,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
          // Draw a white line vertically from the center of the app to the bottom
          Positioned(
            top: MediaQuery.of(context).size.height / 1.8,
            left: MediaQuery.of(context).size.width / 2,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.2,
              width: 1.0,
              color: Colors.white,
            ),
          ),
          // Create the bottom left quadrant (blue)
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.2,
              width: MediaQuery.of(context).size.width / 2,
              color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$_blueCounter',
                    style: TextStyle(
                      fontSize: 200.0,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _blueCounter = max(0, _blueCounter - 1);
                          });
                        },
                        child: Text('Green-'),
                      ),
                      SizedBox(
                          width: 10), // Add some spacing between the buttons
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _blueCounter++;
                          });
                        },
                        child: Text('Green+'),
                      ),
                    ],
                  ),
                      SizedBox(height: 20), // Add some spacing between the score and the new buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          _blueCounter+= 3;
                          _isRidingTimeCountingDown = true;
                          _countRidingTime = true;
                      },
                        child: Text('Takedown'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _blueCounter+= 2;
                            
                            _isRidingTimeCountingDown = true;
                            _countRidingTime = true;

                      },
                      child: Text('Reversal'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                        _blueCounter++;
                          _isRidingTimeCountingDown = false;
                          _countRidingTime = false;
                      },
                       child: Text('Escape'),
                    ),
                  ],
                ),
      
                ],
              ),
            ),
          ),
          // Create the bottom right quadrant (red)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.2,
              width: MediaQuery.of(context).size.width / 2,
              color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$_redCounter',
                    style: TextStyle(
                      fontSize: 200.0,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _redCounter = max(0, _redCounter - 1);
                          });
                        },
                        child: Text('Red-'),
                      ),
                      SizedBox(
                          width: 10), // Add some spacing between the buttons
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _redCounter++;
                          });
                        },
                        child: Text('Red+'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Add some spacing between the score and the new buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          _redCounter+= 3;
                           _ridingTime++;
                           _isRidingTimeCountingDown = false;
                          _countRidingTime = true;

                      },
                      child: Text('Takedown'),
                    ),
                      ElevatedButton(
                        onPressed: () {
                          _redCounter+= 2;
                          _ridingTime++;
                          _isRidingTimeCountingDown = false;
                          _countRidingTime = true;

                      },
                      child: Text('Reversal'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                         _redCounter++;
                         _isRidingTimeCountingDown = false;
                         _countRidingTime = false;

                     },
                     child: Text('Escape'),
                   ),
                  ],
                ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

