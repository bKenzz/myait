import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myait/models/message.dart';

class ChatBubble extends StatefulWidget {
  final String message;

  Timestamp timestamp;

  String messageType;

  bool readStatus;

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
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool editedStatus = false;
  bool being_replyed = false;
  bool being_forwarded = false;
  double deg2rad(double deg) => deg * pi / 180;
  double posX = 0.0;
  double startPosX = 0.0;
  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.9;
    int numberOfLines =
        '\n'.allMatches(formatMessage(widget.message)).length + 1;
    double lineHeight = 20.0; // Change this to your actual line height
    double textHeight = numberOfLines * lineHeight + 30;
    final TextStyle style =
        TextStyle(fontSize: 16); // Specify your font size here
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: widget.message, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    double textWidth = textPainter.width;
    print(textWidth);

    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth * 0.9,
        ),
        child: Stack(alignment: Alignment.center, children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            left: posX,
            key: const ValueKey("item 1"),
            child: Container(
              padding: const EdgeInsets.fromLTRB(3, 0, 5, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue,
              ),
              child: Transform.rotate(
                angle: 0,
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
                              text: formatMessage(widget.message),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        ...List.generate(numberOfLines, (index) => Text('')),
                        Row(
                          children: [
                            (editedStatus == true)
                                ? Text(
                                    "edited ",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.grey[350]),
                                  )
                                : Text(''),
                            Text(
                              widget.timestamp.toDate().hour.toString() +
                                  ":" +
                                  widget.timestamp.toDate().minute.toString(),
                              style: TextStyle(
                                  fontSize: 10, color: Colors.grey[350]),
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
              ),
            ),
          ),
          Positioned(
            child: Container(
              height: textHeight.toDouble(),
              width: textWidth + 70 + (editedStatus ? 30 : 0),
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    startPosX = details.localPosition.dx;
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    double dragDistance = details.localPosition.dx - startPosX;
                    posX = max(-30.0, min(dragDistance, 30.0));
                  });

                  if (posX / 30.0 >= 1.0) {
                    being_replyed = true;
                    print('REPLYING');
                  } else if (posX / -.0 > 1.0) {
                    print('FORWARDING');
                  }
                },
                onPanEnd: (details) {
                  setState(() {
                    posX = 0.0;
                  });
                },
              ),
            ),
          )
        ]),
      ),
    );
  }

  String formatMessage(String message) {
    final int maxWidth = 25;
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
//  GestureDetector(
//       onHorizontalDragEnd: (details) {
//         int sensitivity = 8;
//         if (details.primaryVelocity! < sensitivity) {
//           //TODO FORWARD FUNCTION;
//           print('object');
//         }
//       },
      