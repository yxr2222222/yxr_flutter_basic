import 'package:yxr_flutter_basic/base/http/cache/CacheStrategy.dart';

class CacheConfig {
  /// 默认的缓存时长，接口请求是没有配置缓存时长则使用这个时长
  final int defaultCacheTime;

  CacheConfig({this.defaultCacheTime = CacheStrategy.WEEK});
}
