// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function() onTap;
  final  Color color;
  const MyButton({
    Key? key,
    required this.label,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 100,
        height: 45,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
      color: color
      ),
      child: Text(label,style: const TextStyle(color: Colors.white),),
    ));
  }
}
