class HttpCacheObj {
  /// 缓存的key
  final String cacheKey;
  /// 缓存的内容
  final String cacheValue;
  /// 缓存过期时间
  final int expireTime;
  /// 缓存更新时间
  int updateTime;

  HttpCacheObj(this.cacheKey, this.cacheValue, this.expireTime)
      : updateTime = DateTime.now().millisecondsSinceEpoch;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cacheKey'] = cacheKey;
    data['cacheValue'] = cacheValue;
    data['expireTime'] = expireTime;
    data['updateTime'] = updateTime;
    return data;
  }
}
