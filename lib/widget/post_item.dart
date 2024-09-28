import 'package:blank/Model/post.dart';
import 'package:blank/widget/likes_comment.dart';
import 'package:flutter/material.dart';
class PostItem extends StatelessWidget {
  const PostItem({super.key, required this.post, required this.onTap});

  final Post post;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    const TextStyle commonTextStyle = TextStyle(
      color: Color(0xFF868B94),
      fontSize: 12,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
    );

    return Column(
      children: [
        InkWell(
          onTap: () => onTap(),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(18)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          // for (int i = 0; i < post.categories.length; i++) ...[
                          //   Container(
                          //     padding: const EdgeInsets.symmetric(
                          //         horizontal: 6, vertical: 2),
                          //     child: Text(post.categories[i].title,
                          //         style: GoogleFonts.inter(
                          //             textStyle: const TextStyle(
                          //           color: Color(0xFF1C1B1F),
                          //           fontSize: 10,
                          //           fontWeight: FontWeight.w600,
                          //         ))),
                          //   ),
                          //   const SizedBox(width: 16),
                          // ],
                          // Text(post.,
                          //     style: GoogleFonts.inter(
                          //         textStyle: const TextStyle(
                          //       color: Color(0xFF1C1B1F),
                          //       fontSize: 10,
                          //       fontWeight: FontWeight.w600,
                          //     )))
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        post.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 36,
                        child: Text(
                          post.content,
                          style: const TextStyle(
                            color: Color(0xFF737373),
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            post.authorId,
                            style: commonTextStyle,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              '⸱',
                              textAlign: TextAlign.center,
                              style: commonTextStyle,
                            ),
                          ),
                          Text(
                            post.createdAt.toIso8601String(),
                            style: commonTextStyle,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              '⸱',
                              textAlign: TextAlign.center,
                              style: commonTextStyle,
                            ),
                          ),
                          Text(
                            '조회수 ${post.viewsCount}',
                            style: commonTextStyle,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 76,
                      height: 84,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        image: const DecorationImage(
                          image: NetworkImage("https://shorturl.at/pWUpc"),
                          fit: BoxFit.fitWidth,
                        ),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color:
                                  Colors.black.withOpacity(0.03999999910593033),
                            ),
                            borderRadius: BorderRadius.circular(6)),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    LikesComment(
                      comments: post.commentCount,
                      likes: post.likesCount,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }
}
