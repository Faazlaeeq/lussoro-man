import 'package:flutter/material.dart';
import 'package:single_ecommerce/theme/my_colors.dart';
import 'package:single_ecommerce/theme/sizes.dart';

class CounterWidget extends StatefulWidget {
  CounterWidget({super.key});
  int count = 0;

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 70,
      decoration: BoxDecoration(
          color: MyColors.forgroundWhiteColor,
          borderRadius: BorderRadius.circular(15)),
      padding: const EdgeInsets.all(padding1),
      child: Row(children: [
        InkWell(
            onTap: () {
              setState(() {
                widget.count--;
              });
            },
            child: Text(
              " -  ",
              style: Theme.of(context).textTheme.bodyMedium,
            )),
        Text(" $widget.count ", style: Theme.of(context).textTheme.bodyMedium),
        InkWell(
            onTap: () {
              setState(() {
                widget.count++;
              });
            },
            child: Text("  + ", style: Theme.of(context).textTheme.bodyMedium))
      ]),
    );
  }
}
