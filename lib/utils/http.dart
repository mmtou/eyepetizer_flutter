import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import './constant.dart';

class Http {
  Dio _dio;

  Http() {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: Constant.host,
          connectTimeout: 5000,
          receiveTimeout: 3000,
          headers: {
            'User-Agent': 'eyepetizer_flutter/1.0.0',
            'Accept': '*/*',
            'Cache-Control': 'no-cache',
            'Host': 'baobab.kaiyanapp.com',
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive'
          },
        ),
      );

      _dio.interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        // Do something before request is sent
        return options; //continue
        // If you want to resolve the request with some custom data，
        // you can return a `Response` object or return `dio.resolve(data)`.
        // If you want to reject the request with a error message,
        // you can return a `DioError` object or return `dio.reject(errMsg)`
      }, onResponse: (Response response) async {
        // Do something with response data
        return response; // continue
      }, onError: (DioError e) async {
        BotToast.showText(text: '服务器异常');
        // Do something with response error
        return e; //continue
      }));
    }
  }

  Future get(uri, {queryParameters}) async {
    try {
      Response response = await _dio.get(uri, queryParameters: queryParameters);
//      print(response);
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
