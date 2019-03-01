import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:xiaoyanshuo_beta/config/Global.dart';
import 'package:xiaoyanshuo_beta/utils/ResultData.dart';

class HttpManager {
  static Future<ResultData> request(String url, {params, method}) async {
    //检查网络链接
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    }else{
      return ResultData("网络连接失败", 111);
    }

    if (method == null) {
      method = 'GET';
    }
    Dio dio = new Dio();
    Options options;
    if (options == null) {
      var now = new DateTime.now().millisecondsSinceEpoch.toString();

      var bite = Global.appId +
          'UZ' +
          Global.appKey +
          'UZ' +
          now;
      var appCode = sha1.convert(utf8.encode(bite)).toString() + "." + now;

      options = new Options(method: method);
      options.baseUrl = "https://d.apicloud.com/mcm/api";
      options.headers = {
        "X-APICloud-AppId": Global.appId,
        "X-APICloud-AppKey": appCode
      };
      options.connectTimeout = 10000; //5s
      options.receiveTimeout = 3000;
    } else {
      options.method = method;
    }

    try {
      Response response =
          await dio.request(url, data: params, options: options);
      // Loading.hideLoading(context);
      return ResultData(response.data, response.statusCode);
    } on DioError catch (e) {
      // Loading.hideLoading(context);
      var errorResponse;
      errorResponse = e.response;
      if (errorResponse == null) {
        errorResponse = e.message;
      }

      return ResultData(errorResponse, 111);
    }
  }
}
