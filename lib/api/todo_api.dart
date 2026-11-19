import 'dart:math';
import 'package:dio/dio.dart';
import '../models/todo.dart';

class TodoApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  Future<T> withRetry<T>(
    Future<T> Function() op, {
    void Function(String logMessage)? onRetryLog,
  }) async {
    final random = Random();

    for (var i = 0;; i++) {
      try {
        return await op();
      } on DioException catch (e) {
        final statusCode = e.response?.statusCode;
        final isRetryable = statusCode == null ||
            statusCode == 408 ||
            statusCode == 429 ||
            statusCode >= 500 ||
            statusCode == 404;

        if (!isRetryable || i == 4) {
          onRetryLog?.call(
            'Attempt ${i + 1} failed (${statusCode ?? e.type.name}). Giving up.',
          );
          rethrow;
        }

        final baseDelay = 400 * (1 << i);
        final jitter = random.nextInt(baseDelay);
        final totalDelay = baseDelay + jitter;

        onRetryLog?.call(
          'Attempt ${i + 1} failed (${statusCode ?? e.type.name}). '
          'Retrying in ${totalDelay}ms (base: ${baseDelay}ms + jitter: ${jitter}ms)...',
        );

        await Future.delayed(Duration(milliseconds: totalDelay));
      }
    }
  }

  Future<List<Todo>> fetchTodos({
    String path = '/todos',
    void Function(String logMessage)? onRetryLog,
  }) {
    return withRetry(() async {
      final res = await _dio.get(path);
      final raw = res.data as List<dynamic>;
      return raw
          .map((j) => Todo.fromJson(j as Map<String, dynamic>))
          .toList();
    }, onRetryLog: onRetryLog);
  }
}