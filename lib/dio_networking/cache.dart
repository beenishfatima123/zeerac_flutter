import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CacheOption {
  CachePolicy cachePolicy = CachePolicy.forceCache;
  late CacheOptions _options;

  CacheOptions get options {
    return _options;
  }

  CacheOption(CachePolicy cachePolicy) {
    _options = CacheOptions(

        // A default store is required for interceptor.
        store: kIsWeb ? MemCacheStore() : HiveCacheStore('path'),
        // Default.
        // Optional. Returns a cached response on error but for statuses 401 & 403.
        hitCacheOnErrorExcept: [401, 403],
        // Optional. Overrides any HTTP directive to delete entry past this duration.
        maxStale: const Duration(minutes: 30),
        // Default. Allows 3 cache sets and ease cleanup.
        priority: CachePriority.high,
        // Default. Body and headers encryption with your own algorithm.
        // Default. Key builder to retrieve requests.
        keyBuilder: CacheOptions.defaultCacheKeyBuilder,
        // Default. Allows to cache POST requests.
        // Overriding [keyBuilder] is strongly recommended.
        allowPostMethod: true,
        policy: cachePolicy);
  }
}

// Global options
