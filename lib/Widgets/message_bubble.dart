import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessageBubble extends StatelessWidget {
  final String message, userName;
  final bool isMe;
  final String? imageUrl;
  const MessageBubble({
    Key? key,
    required this.message,
    required this.userName,
    required this.isMe,
    required this.imageUrl,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          // decoration: BoxDecoration(
          //   color: isMe ? Colors.red : Colors.blueGrey,
          //   borderRadius: BorderRadius.only(
          //     topRight: const Radius.circular(15),
          //     topLeft: const Radius.circular(15),
          //     bottomLeft: Radius.circular(isMe ? 15 : 0),
          //     bottomRight: Radius.circular(isMe ? 0 : 15),
          //   ),
          // ),
          // padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(500),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl ??
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bb/Octicons-cloud-upload.svg/1200px-Octicons-cloud-upload.svg.png',
                      width: 75,
                      height: 75,
                      fit: BoxFit.fill,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: isMe ? Colors.red : Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(15),
                    topLeft: const Radius.circular(15),
                    bottomLeft: Radius.circular(isMe ? 15 : 0),
                    bottomRight: Radius.circular(isMe ? 0 : 15),
                  ),
                ),
                padding: const EdgeInsets.all(7),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
