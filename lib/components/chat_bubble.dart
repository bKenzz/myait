import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;

  Timestamp timestamp;

  String messageType;

  bool readStatus;

  bool editedStatus = false;

  bool forwarded;

  final String senderId;

  ChatBubble(
      {Key? key,
      required this.message,
      required this.senderId,
      required this.timestamp,
      required this.readStatus,
      required this.messageType,
      required this.forwarded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.blue,
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: formatMessage(message),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Text(' '),
              Row(
                children: [
                  (editedStatus == true)
                      ? Text(
                          "edited",
                          style:
                              TextStyle(fontSize: 10, color: Colors.grey[350]),
                        )
                      : Text(''),
                  Text(
                    timestamp.toDate().hour.toString() +
                        ":" +
                        timestamp.toDate().minute.toString(),
                    style: TextStyle(fontSize: 10, color: Colors.grey[350]),
                  ),
                  Icon(
                    Icons.check,
                    size: 10,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatMessage(String message) {
    final int maxWidth = 30;
    int currentWidth = 0;

    StringBuffer formattedMessage = StringBuffer();

    for (int i = 0; i < message.length; i++) {
      var char = message[i];
      if (char == ' ' && currentWidth >= maxWidth) {
        formattedMessage.write('\n');
        currentWidth = 0;
      } else {
        formattedMessage.write(char);
        if (char != ' ' && currentWidth == maxWidth) {
          formattedMessage.write('\n');
          currentWidth = 0;
        } else {
          currentWidth++;
        }
      }
    }

    return formattedMessage.toString();
  }
}
