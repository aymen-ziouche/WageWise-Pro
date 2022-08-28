import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _isHours = true;
  int money = 5;
  final myController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        title: const Text('Home Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        backgroundColor: Colors.black,
                        title: const Text(
                          'Settings',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        content: TextField(
                          style: const TextStyle(color: Colors.white),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          onSubmitted: (value) {
                            setState(() {
                              money = int.parse(value);
                            });
                            Navigator.pop(context);
                          },
                          controller: myController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white10,
                            labelText: 'Enter yout hourly rate',
                            labelStyle: TextStyle(color: Colors.white),
                            hintText: "eg. 15\$/hr",
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                      ));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snapshot) {
                final value = snapshot.data;
                final displaytime =
                    StopWatchTimer.getDisplayTime(value!, hours: _isHours);
                var minute = StopWatchTimer.getDisplayTimeMinute(
                    _stopWatchTimer.rawTime.value);
                var minuteint = int.parse(minute);
                return CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 10.0,
                  percent: minuteint / 60,
                  center: Text(
                    displaytime,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  progressColor: Colors.lightBlue,
                  backgroundColor: Colors.blueGrey,
                  animation: true,
                  animateFromLastPercent: true,
                  animationDuration: 1000,
                  circularStrokeCap: CircularStrokeCap.round,
                  restartAnimation: true,
                );
              },
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(30)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: const BorderSide(
                                  color: Colors.green, width: 3.0)))),
                  onPressed: () {
                    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                  },
                  child: const Text('Start', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 10),
                TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(30)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                              side: const BorderSide(
                                  color: Colors.red, width: 3.0)))),
                  onPressed: () {
                    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                  },
                  child: const Text('Stop', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
            const SizedBox(height: 40),
            TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.all(30)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueGrey),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: const BorderSide(
                              color: Colors.blueGrey, width: 3.0)))),
              onPressed: () {
                _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
              },
              child: const Text('Reset', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 40),
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: money,
              builder: (context, snapshot) {
                var now = StopWatchTimer.getDisplayTimeHours(
                    _stopWatchTimer.rawTime.value);
                var nowint = int.parse(now);

                return Text("You made : ${nowint * money}\$",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
