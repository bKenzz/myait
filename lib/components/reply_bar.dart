import 'package:flutter/material.dart';

class ReplyBar extends StatelessWidget {
  final String? replyingTo;
  final String? messageSnippet;
  final VoidCallback? onCancelReply;

  ReplyBar({
    Key? key,
    this.replyingTo,
    this.messageSnippet,
    this.onCancelReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This bar should be hidden when not replying to a message
    if (replyingTo == null || messageSnippet == null) return SizedBox();

    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Choose a light color that matches your theme
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to $replyingTo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                Text(
                  messageSnippet!,
                  style: TextStyle(color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: onCancelReply,
          ),
        ],
      ),
    );
  }
}
