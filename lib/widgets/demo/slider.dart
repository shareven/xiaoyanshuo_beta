import 'package:flutter/material.dart';

class SliderDemo extends StatefulWidget {
  @override
  _SliderDemoState createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> {
  double _sliderItem = 23.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Slider(
            value: _sliderItem,
            onChanged: (double value) {
              setState(() {
                _sliderItem = value;
              });
            },
            activeColor: Theme.of(context).accentColor,
            inactiveColor: Theme.of(context).primaryColor.withOpacity(0.3),
            min: -20.0,
            max: 60.0,
            divisions: 20,
            label: '${_sliderItem}',
          ),
          SizedBox(height: 10.0,),
          Text("_sliderItem: $_sliderItem")
        ],
      ),
    );
  }
}
