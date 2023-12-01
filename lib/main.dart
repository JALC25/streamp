import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi APP',
      home: StreamExample(),
    );
  }
}

class StreamExample extends StatefulWidget {
  @override
  _StreamExampleState createState() => _StreamExampleState();
}

class _StreamExampleState extends State<StreamExample> {
  final StreamController<String> _streamController = StreamController<String>();
  List<String> _dataList = [];
  Timer? _timer;
  bool _isTimerRunning = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _streamController.sink.add("JENCI LEMUS: ${DateTime.now()}");
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _toggleTimer() {
    if (_isTimerRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
    setState(() {
      _isTimerRunning = !_isTimerRunning;
    });
  }

  @override
  void dispose() {
    _streamController.close();
    _stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MI APP'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<String>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  _dataList.add(snapshot.data ?? "");

                  return ListView.builder(
                    itemCount: _dataList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_dataList[index]),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toggleTimer();
        },
        child: Icon(_isTimerRunning ? Icons.pause : Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
