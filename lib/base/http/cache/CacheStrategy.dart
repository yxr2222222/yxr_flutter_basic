class CacheStrategy {
  /// 缓存模式的参数key
  static const String CACHE_MODE = "Key-Cache-Mode";

  /// 缓存事件的参数key
  static const String CACHE_TIME = "Key-Cache-Time";

  /// 自定义缓存key的参数key
  static const String CUSTOM_CACHE_KEY = "Key-Cache-Key";

  /// 一分钟的毫秒数
  static const int MINUTE = 60 * 1000;

  /// 一小时的毫秒数
  static const int HOUR = 60 * MINUTE;

  /// 一天的毫秒数
  static const int DAY = 24 * HOUR;

  /// 一星期的毫秒数
  static const int WEEK = 7 * DAY;

  /// 一个月的毫秒数
  static const int MONTH = 30 * DAY;
}
