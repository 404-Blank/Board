class TimeCalculate {
  // 타임스탬프(밀리초)를 받아 시간 경과를 계산
  static String timeAgo(int createdAtMillis) {
    // 밀리초 값을 DateTime으로 변환
    final createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtMillis);
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}초 전';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}시간 전';
    } else {
      return '${difference.inDays}일 전';
    }
  }
}
