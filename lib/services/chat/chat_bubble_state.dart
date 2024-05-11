// import 'package:flutter/material.dart';
// import 'package:myait/components/chat_bubble.dart';

// class _ChatBubbleState extends State<ChatBubble> {
//   double dragOffset = 0; // Initial offset is 0

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onHorizontalDragUpdate: (details) {
//         // Set state to update UI with new drag offset
//         setState(() {
//           dragOffset -= details.primaryDelta!;
//           if (dragOffset < -30) dragOffset = -30; // Limit to -30 pixels
//           if (dragOffset > 0)
//             dragOffset = 0; // Limit to 0 pixels (no rightward movement)
//         });
//       },
//       onHorizontalDragEnd: (details) {
//         // When drag ends, reset the offset to 0
//         setState(() {
//           dragOffset = 0;
//         });

//         int sensitivity = 8;
//         if (details.primaryVelocity! > -sensitivity) {
//           //TODO: FORWARD FUNCTION;
//         }
//       },
//       child: Transform.translate(
//         offset: Offset(dragOffset, 0), // Apply the dragOffset here
//         child: ChatBubble(
//           message: data['text'],
//           timestamp: data["timestamp"],
//           readStatus: false,
//           messageType: 'default',
//           forwarded: false,
//           senderId: data['senderId'],
//         ),
//       ),
//     );
//   }
// }
