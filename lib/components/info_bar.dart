import 'package:flutter/material.dart';

class InfoBar extends StatelessWidget {
  final double height;
  final Color bgColor;
  final String title;
  final String message;
  final Widget icon;
  final double textSize;
  final bool isGradient;
  const InfoBar({
    super.key,
    this.isGradient = false,
    required this.bgColor,
    required this.height,
    required this.title,
    required this.message,
    required this.icon,
    required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: isGradient
          ? BoxDecoration(
              // gradient: LinearGradient(
              //   begin: Alignment.centerLeft,
              //   end: Alignment.centerRight,
              //   colors: [
              //     Colors.black.withOpacity(0.8),
              //     Colors.black.withOpacity(0.4),
              //   ],
              // ),

              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.3),
                ],
                stops: const [0.2, 0.5, 1.0],
              ),
            )
          : BoxDecoration(color: bgColor),
      child: Row(
        children: [
          const SizedBox(width: 6),
          icon,
          const SizedBox(width: 6),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: title,
                style: TextStyle(
                  fontSize: textSize,
                  color: isGradient ? Colors.white.withOpacity(0.8) : Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: message,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    // Container(
    //   width: double.infinity,
    //   height: height,
    //   decoration: BoxDecoration(
    //     color: bgColor,
    //   ),
    //   child: Row(
    //     children: [
    //       const SizedBox(width: 6),
    //       icon,
    //       const SizedBox(width: 6),
    //       Expanded(
    //         child: Text.rich(
    //           TextSpan(
    //             text: title,
    //             style: TextStyle(
    //               fontSize: textSize,
    //               color: Colors.white,
    //               fontWeight: FontWeight.w400,
    //             ),
    //             children: [
    //               TextSpan(
    //                 text: message,
    //                 style: const TextStyle(
    //                   fontWeight: FontWeight.w500,
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //               ),
    //             ],
    //           ),
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
