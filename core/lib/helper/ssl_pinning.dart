import 'package:ssl_pinning_plugin/ssl_pinning_plugin.dart';

class SslPinningHelper {

  Future<bool> isSecure(String url) async {
    bool secure = false;
    String fingerprint = "60 DD F6 CA 48 50 EC 0F 4B B6 96 0C 1F C4 3E 2B D3 B3 5E 6D";
    List<String> allowedSHAFingerprints = [];
    allowedSHAFingerprints.add(fingerprint);
    var uri = Uri.parse(url);
    try {
      String message = await SslPinningPlugin.check(
          serverURL: uri.toString(),
          sha: SHA.SHA1,
          allowedSHAFingerprints: allowedSHAFingerprints,
          timeout: 60
      );
      if (message == 'CONNECTION_SECURE') {
        secure = true;
      } else {
        secure = false;
      }
    } catch (e) {
      secure = false;
    }
    return secure;
  }
}