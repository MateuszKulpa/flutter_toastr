import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppPage(),
    );
  }
}

class AppPage extends StatefulWidget {
  @override
  AppPageState createState() {
    return new AppPageState();
  }
}

class AppPageState extends State<AppPage> {
  NotificationType _selectedType = NotificationType.success;
  Alignment _selectedAlignment = Alignment.bottomCenter;
  int _selectedMillis = 2000;
  TextEditingController _durationTextController;
  List<Alignment> _alignments = [
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight,
  ];

  Widget _buildNotificationTypeCheckboxes() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: NotificationType.values.map((el) {
          return Column(
            children: [
              Checkbox(
                value: _selectedType == el,
                onChanged: (val) {
                  setState(() {
                    _selectedType = el;
                  });
                },
              ),
              Text(el.toString().split('.')[1])
            ],
          );
        }).toList());
  }

  Widget _buildAlignmentCheckboxes() {
    return Container(
      height: 220.0,
      child: GridView.count(
        childAspectRatio: 1.8,
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        children: _alignments.map((el) {
          return Column(
            children: [
              Checkbox(
                value: _selectedAlignment == el,
                onChanged: (val) {
                  setState(() {
                    _selectedAlignment = el;
                  });
                },
              ),
              Text(el.toString()),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDurationInput() {
    return TextField(
      controller: _durationTextController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: OutlineInputBorder(), labelText: 'Duration in millis'),
    );
  }

  @override
  void initState() {
    _durationTextController =
        TextEditingController(text: _selectedMillis.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_toastr demo'),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () {
            Toastr.show(
              context: context,
              child: Text('This is example child of notification'),
              duration: Duration(
                  milliseconds: int.tryParse(_durationTextController.text)),
              alignment: _selectedAlignment,
              type: _selectedType,
            );
          }),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Type',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 18.0)),
            _buildNotificationTypeCheckboxes(),
            SizedBox(height: 24.0),
            Text('Alignment',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 28.0)),
            SizedBox(height: 8.0),
            _buildAlignmentCheckboxes(),
            SizedBox(height: 8.0),
            _buildDurationInput()
          ],
        ),
      ),
    );
  }
}
