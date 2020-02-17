import 'package:bot_toast/bot_toast.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import './constant.dart';

class Common {
  // 拼接url
  static getUrl(String url) {
    var temp = url.replaceAll(Constant.host, '');
    List<String> result;
    if (temp.indexOf('?') >= 0) {
      result = [temp, '&udid=', Constant.udid];
    } else {
      result = [temp, '?udid=', Constant.udid];
    }
    result.add('&vc=580&deviceModel=ONEPLUS%20A6000');
    String finalUrl = result.join('');
    return finalUrl.replaceAll(
        '/api/v5/index/tab/discovery', '/api/v7/index/tab/discovery');
  }

  // 格式化时长
  static secondToDate(num second) {
    prefixInteger(num) {
      var temp = '00$num';
      return temp.substring(temp.length - 2);
    }

    format(h, m, s) {
      List result = [];
      if (h != null && h != 0) {
        result.add(prefixInteger(h));
      }
      if (h != null && h != 0 || m != null && m != 0) {
        result.add(prefixInteger(m));
      }
      if (h != null && h != 0 || m != null && m != 0 || s != null && s != 0) {
        result.add(prefixInteger(s));
      }
      return result.join(':');
    }

    var h = (second / 3600).floor();
    var m = (second / 60 % 60).floor();
    var s = (second % 60).floor();

    return format(h, m, s);
  }

  // 分享
  static share(String message) {
    Share.share(message);
  }

  // 浏览器打开
  static openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      BotToast.showText(text: '无法打开');
    }
  }
}
