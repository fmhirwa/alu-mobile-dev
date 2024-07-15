import 'package:flutter/material.dart';
import 'widgets/conversion_selector.dart';
import 'widgets/temperature_input.dart';
import 'widgets/conversion_result.dart';
import 'widgets/history_list.dart';
import 'widgets/convert_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(TempConverterApp());

class TempConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: TempConverterHomePage(),
    );
  }
}

class TempConverterHomePage extends StatefulWidget {
  @override
  _TempConverterHomePageState createState() => _TempConverterHomePageState();
}

class _TempConverterHomePageState extends State<TempConverterHomePage> {
  bool isFahrenheitToCelsius = true;
  String input = '';
  String result = '';
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      history = prefs.getStringList('history') ?? [];
    });
  }

  Future<void> _saveHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('history', history);
  }

  void convert() {
    double temp = double.tryParse(input) ?? 0;
    double convertedTemp;

    if (isFahrenheitToCelsius) {
      convertedTemp = (temp - 32) * 5 / 9;
      history.insert(0, 'F to C: $temp => ${convertedTemp.toStringAsFixed(1)}°C');
      result = '${convertedTemp.toStringAsFixed(1)}°C';
    } else {
      convertedTemp = temp * 9 / 5 + 32;
      history.insert(0, 'C to F: $temp => ${convertedTemp.toStringAsFixed(1)}°F');
      result = '${convertedTemp.toStringAsFixed(1)}°F';
    }

    setState(() {
      input = '';
      _saveHistory();
    });
  }

  void onInputChanged(String value) {
    setState(() {
      input = value;
      result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Converter'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (orientation == Orientation.portrait) ...[
                    Column(
                      children: <Widget>[
                        ConversionSelector(
                          isFahrenheitToCelsius: isFahrenheitToCelsius,
                          onChanged: (value) {
                            setState(() {
                              isFahrenheitToCelsius = value;
                            });
                          },
                        ),
                        TemperatureInput(
                          value: input,
                          onChanged: onInputChanged,
                        ),
                        ConversionResult(result: result),
                        ConvertButton(onPressed: convert),
                      ],
                    ),
                    HistoryList(history: history),
                  ] else ...[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              ConversionSelector(
                                isFahrenheitToCelsius: isFahrenheitToCelsius,
                                onChanged: (value) {
                                  setState(() {
                                    isFahrenheitToCelsius = value;
                                  });
                                },
                              ),
                              TemperatureInput(
                                value: input,
                                onChanged: onInputChanged,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              ConversionResult(result: result),
                              ConvertButton(onPressed: convert),
                            ],
                          ),
                        ),
                      ],
                    ),
                    HistoryList(history: history),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
