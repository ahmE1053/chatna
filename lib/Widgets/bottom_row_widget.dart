import 'package:cross_connectivity/cross_connectivity.dart' as connect;
import 'package:flutter/material.dart';

class BottomTextRow extends StatefulWidget {
  const BottomTextRow({
    Key? key,
    required TextEditingController textController,
    required this.sendMessage,
  })  : _textController = textController,
        super(key: key);
  final TextEditingController _textController;
  final Function(String text, BuildContext context) sendMessage;
  @override
  State<BottomTextRow> createState() => _BottomTextRowState();
}

class _BottomTextRowState extends State<BottomTextRow> {
  TextDirection getDirection(String v) {
    final string = v.trim();
    if (string.isEmpty) return TextDirection.ltr;
    final firstUnit = string.codeUnitAt(0);
    if (firstUnit > 0x0600 && firstUnit < 0x06FF ||
        firstUnit > 0x0750 && firstUnit < 0x077F ||
        firstUnit > 0x07C0 && firstUnit < 0x07EA ||
        firstUnit > 0x0840 && firstUnit < 0x085B ||
        firstUnit > 0x08A0 && firstUnit < 0x08B4 ||
        firstUnit > 0x08E3 && firstUnit < 0x08FF ||
        firstUnit > 0xFB50 && firstUnit < 0xFBB1 ||
        firstUnit > 0xFBD3 && firstUnit < 0xFD3D ||
        firstUnit > 0xFD50 && firstUnit < 0xFD8F ||
        firstUnit > 0xFD92 && firstUnit < 0xFDC7 ||
        firstUnit > 0xFDF0 && firstUnit < 0xFDFC ||
        firstUnit > 0xFE70 && firstUnit < 0xFE74 ||
        firstUnit > 0xFE76 && firstUnit < 0xFEFC ||
        firstUnit > 0x10800 && firstUnit < 0x10805 ||
        firstUnit > 0x1B000 && firstUnit < 0x1B0FF ||
        firstUnit > 0x1D165 && firstUnit < 0x1D169 ||
        firstUnit > 0x1D16D && firstUnit < 0x1D172 ||
        firstUnit > 0x1D17B && firstUnit < 0x1D182 ||
        firstUnit > 0x1D185 && firstUnit < 0x1D18B ||
        firstUnit > 0x1D1AA && firstUnit < 0x1D1AD ||
        firstUnit > 0x1D242 && firstUnit < 0x1D244) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }

  final ValueNotifier<TextDirection> _textDir =
      ValueNotifier(TextDirection.ltr);
  String _textFieldEntry = '';
  @override
  Widget build(BuildContext context) {
    return connect.ConnectivityBuilder(builder: (context, isConnected, status) {
      return Row(
        children: [
          Expanded(
            child: ValueListenableBuilder<TextDirection>(
              valueListenable: _textDir,
              builder: (context, directionValue, child) => TextField(
                textDirection: directionValue,
                onChanged: (input) {
                  if (input.trim().length < 2) {
                    final dir = getDirection(input);
                    if (dir != directionValue) _textDir.value = dir;
                  }
                  setState(() {
                    _textFieldEntry = input;
                  });
                },
                onSubmitted: (value) {
                  widget.sendMessage(_textFieldEntry, context);
                },
                decoration: InputDecoration(
                  enabled: isConnected == false ||
                          status == connect.ConnectivityStatus.unknown
                      ? false
                      : true,
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  hintText: isConnected == false ||
                          status == connect.ConnectivityStatus.unknown
                      ? 'Please connect to a network'
                      : 'Send a message',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                cursorColor: Colors.red,
                textInputAction: TextInputAction.newline,
                maxLines: 4,
                minLines: 1,
                controller: widget._textController,
              ),
            ),
          ),
          IconButton(
            disabledColor: Colors.grey,
            color: Colors.red,
            onPressed: _textFieldEntry == ''
                ? null
                : isConnected == false ||
                        status == connect.ConnectivityStatus.unknown
                    ? null
                    : () {
                        widget.sendMessage(_textFieldEntry, context);
                        _textFieldEntry = '';
                      },
            icon: const Icon(
              Icons.send_outlined,
            ),
          ),
        ],
      );
    });
  }
}
