import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:myait/models/message.dart';
import 'package:myait/services/chat/chat_service.dart';

class ChatBubble extends StatefulWidget {
  final Function(String, String, String) onReply; // Add this line

  late String message;
  final String id;
  Timestamp timestamp;
  final String chatRoomId;
  String messageType;
  Timestamp editedStatus;
  bool readStatus;
  final String? replyMessage; // Add this line to hold the reply message

  bool forwarded;

  final String senderId;

  ChatBubble({
    Key? key,
    required this.onReply,
    required this.editedStatus,
    required this.message,
    required this.senderId,
    required this.timestamp,
    required this.readStatus,
    required this.messageType,
    required this.forwarded,
    required this.id,
    required this.chatRoomId,
    required this.replyMessage,
  }) : super(key: key);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  void initState() {
    super.initState();
    editedStatus = widget.editedStatus;
    if (editedStatus != widget.timestamp) {
      setState(() {});
    }
  }

  late String message;
  late Timestamp editedStatus;
  @override
  void didUpdateWidget(ChatBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editedStatus != oldWidget.editedStatus) {
      setState(() {
        editedStatus = widget.editedStatus;
      });
    }
    if (widget.message != oldWidget.message) {
      setState(() {
        message = widget.message;
      });
    }
  }

  bool being_replyed = false;
  bool being_forwarded = false;
  double deg2rad(double deg) => deg * pi / 180;
  double posX = 0.0;
  double startPosX = 0.0;
  ChatService _chatService = ChatService();
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
    return Column(
      children: [
        if (widget.replyMessage != '') ...[
          Text(
            'Reply to: ${widget.replyMessage!.length > 20 ? widget.replyMessage!.substring(0, 18) + '...' : widget.replyMessage}',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
        ],
        GestureDetector(
          onLongPress: () {
            print(widget.id);
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: AlertDialog(
                            backgroundColor: Colors.transparent,
                            content: Container(
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
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons
                              .arrow_forward), // replace with your desired icon
                          label: Text('Forward'),
                          onPressed: () {
                            // handle button press
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: ElevatedButton.icon(
                          icon: Icon(
                              Icons.edit), // replace with your desired icon
                          label: Text('Edit     '),
                          onPressed: () {
                            editMessage(context);
                            // handle button press
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: ElevatedButton.icon(
                          icon: Icon(
                              Icons.reply), // replace with your desired icon
                          label: Text('Reply'),
                          onPressed: () {
                            reply_function();
                            Navigator.of(context).pop();
                            // handle button press
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons
                              .content_copy), // replace with your desired icon
                          label: Text('Copy'),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: widget.message));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Message copied to clipboard'),
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons
                              .select_all), // replace with your desired icon
                          label: Text('Select'),
                          onPressed: () {
                            // handle button press
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: ElevatedButton.icon(
                          icon: Icon(
                              Icons.delete), // replace with your desired icon
                          label: Text('Delete'),
                          onPressed: () {
                            delete_message();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Container(
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
                          //REPLY
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
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              ...List.generate(
                                  numberOfLines, (index) => Text('')),
                              Row(
                                children: [
                                  (editedStatus != widget.timestamp)
                                      ? Text(
                                          "edited " +
                                              editedStatus
                                                  .toDate()
                                                  .hour
                                                  .toString() +
                                              ":" +
                                              editedStatus
                                                  .toDate()
                                                  .minute
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[350]),
                                        )
                                      : Text(
                                          widget.timestamp
                                                  .toDate()
                                                  .hour
                                                  .toString() +
                                              ":" +
                                              widget.timestamp
                                                  .toDate()
                                                  .minute
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey[350]),
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
                    width: (textWidth) +
                        70 +
                        (editedStatus != widget.timestamp ? 20 : 0),
                    child: GestureDetector(
                      onPanStart: (details) {
                        setState(() {
                          startPosX = details.localPosition.dx;
                        });
                      },
                      onPanUpdate: (details) {
                        setState(() {
                          double dragDistance =
                              details.localPosition.dx - startPosX;
                          posX = max(-30.0, min(dragDistance, 30.0));
                        });

                        if (posX / 30.0 >= 1.0) {
                          being_replyed = true;
                          reply_function();
                          print(textWidth);
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
          ),
        ),
      ],
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

  void delete_message() async {
    await _chatService.delete_message(widget.chatRoomId, widget.id);
  }

  void editMessage(
    BuildContext context,
  ) async {
    TextEditingController _controller =
        TextEditingController(text: widget.message);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Message'),
          content: TextField(
            controller: _controller,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                setState(() {
                  widget.message = _controller.text;
                });

                await _chatService.editMessage(
                    widget.chatRoomId, widget.id, widget.message);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  reply_function() {
    widget.onReply(widget.id, widget.chatRoomId, widget.message);
  }
}
