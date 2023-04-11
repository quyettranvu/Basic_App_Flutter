// import 'package:flutter/material.dart';
//
// class Screen2 extends StatelessWidget{
//   static const routeName = "/screen-2";
//
//   @override
//   Widget build(BuildContext context){
//     var arguments = ModalRoute.of(context)?.settings.arguments as String;
//
//     return Scaffold(
//       body: Center(
//         child: Text(arguments),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.access_alarm),
//         onPressed: () => Navigator.of(context).pop(),
//       ),
//     );
//   }
// }