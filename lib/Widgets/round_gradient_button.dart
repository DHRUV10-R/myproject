import 'package:flutter/material.dart';

class RoundGradientButton extends StatelessWidget{
  final String title;
  final Function() onPressed;

  const RoundGradientButton({
    super.key,
    required this.title,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: Colors.primaries,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(color: Color.fromARGB(66, 230, 225, 225),blurRadius: 2,offset: Offset(0, 2)),
            ],
            ),
            child: MaterialButton(onPressed: onPressed,
            minWidth: double.maxFinite,
            height: 50,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),
            ),
            textColor: Color.fromARGB(255, 5, 172, 244),
            child: Text(title,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 10, 9, 9),
              fontWeight: FontWeight.w700,
            ),
            ),
            ),
      ),

    );
  }
}