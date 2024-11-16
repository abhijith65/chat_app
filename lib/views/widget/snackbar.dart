import 'package:flutter/material.dart';

msgSnackbar(context,String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text("$msg.."),
          backgroundColor: Colors.green,
        ));