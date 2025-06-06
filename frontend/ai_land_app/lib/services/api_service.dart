import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  static const String baseUrl = 'https://api.siliconflow.cn';
  static const String apiKey =
      'sk-vtlqlmmjkdmwnkyueoqnzjoibaiqfrllufjhstaxgdortpho';

  Future<StreamSubscription?> chatCompletions({
    required String prompt,
    Function(String)? onData,
    Function()? onDone,
    Function(dynamic)? onError,
  }) async {
    final response = await _dio.post(
      '$baseUrl/chat/completions',
      options: Options(
        receiveTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        responseType: ResponseType.stream,
      ),
      data: {
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'model': 'Qwen/Qwen2.5-7B-Instruct',
        'stream': true,
        'max_tokens': 1000,
        'temperature': 0.5,
      },
    );

    final responseBody = response.data as ResponseBody;
    final subscription = responseBody.stream.listen(
      (data) {
        final chunk = utf8.decode(data);
        onData?.call(chunk);
      },
      onDone: () {
        onDone?.call();
      },
      onError: (error) {
        onError?.call(error);
      },
    );

    return subscription;
  }
}
