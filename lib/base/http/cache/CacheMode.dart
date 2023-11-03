enum CacheMode {
  /// 只请求网络，默认 (不加缓存)
  ONLY_NETWORK,

  /// 先读取缓存，缓存失效再请求网络更新缓存
  READ_CACHE_NETWORK_PUT,

  /// 先请求网络，网络请求失败使用缓存(网络请求成功，写入缓存)
  NETWORK_PUT_READ_CACHE;
}
