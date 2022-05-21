import 'dart:io';

import 'package:chatna/Models/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickingImageWidget extends StatefulWidget {
  const PickingImageWidget({Key? key}) : super(key: key);
  @override
  State<PickingImageWidget> createState() => _PickingImageWidgetState();
}

class _PickingImageWidgetState extends State<PickingImageWidget> {
  String? i;
  @override
  Widget build(BuildContext context) {
    final _authenticationData = Provider.of<Authentication>(context);
    // print(widget.imageUrl);
    return GestureDetector(
      onTap: () async {
        try {
          i = await _authenticationData.selectAnImage(context);
        } catch (error) {}
        setState(() {});
      },
      child: i == null
          ? const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.red,
              child: Icon(
                Icons.add,
                size: 50,
                color: Colors.white,
              ),
            )
          : CircleAvatar(
              radius: 60,
              backgroundImage: FileImage(
                File(
                  i!,
                ),
              ),
            ),
    );
  }
}
