import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class LikesComment extends StatelessWidget {
  const LikesComment({super.key, required this.comments, required this.likes});

  final int comments;
  final int likes;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 15,
          height: 15,
          child:
              // SvgPicture.asset(
              //   'lib/asset/icon/icon_reply.svg',
              // ),
              Icon(
            Icons.mode_comment_outlined,
            color: Color(0xFF868B94),
            size: 15,
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          comments.toString(),
          style: const TextStyle(
            color: Color(0xFF868B94),
            fontSize: 13,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            height: 0.12,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        const SizedBox(
          width: 15,
          height: 15,
          child:
              // SvgPicture.asset(
              //   'lib/asset/icon/icon_thumb_up.svg',
              // ),
              Icon(
            Icons.thumb_up_outlined,
            color: Color(0xFF868B94),
            size: 15,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          likes.toString(),
          style: const TextStyle(
            color: Color(0xFF868B94),
            fontSize: 13,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            height: 0.12,
          ),
        )
      ],
    );
  }
}
