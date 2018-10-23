//import 'package:flutter/material.dart';
//import 'dart:async';
//class Toast extends StatefulWidget {
//
//  Toast(this.message);
//  @override
//  _ToastState createState() => _ToastState(message);
//}
//
//class _ToastState extends State<Toast> {
//  String message;
//  _ToastState(this.message);
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}
//
//void showToast(BuildContext context, String text) async {
//  OverlayState overlayState = Overlay.of(context);
//  OverlayEntry overlayEntry = OverlayEntry(
//      opaque: false,
//      builder: (context) {
//        return Positioned(
////            top: 5.0,
////            height: 20.0,
//          bottom: 35.0,
//          left: 100.0,
////            right: 60.0,
//          child: Container(
////              width: 200.0,
//            padding: EdgeInsets.all(16.0),
//            decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(20.0),
//                color: Colors.cyan),
////              color: Colors.grey,
//            child: Center(
//              child: Material(
//                color: Colors.transparent,
//                child: Text(text),
//              ),
//            ),
//          ),
//        );
//      });
//
//  overlayState.insert(overlayEntry);
//  await Future.delayed(Duration(seconds: 1));
//  overlayEntry.remove();
//}