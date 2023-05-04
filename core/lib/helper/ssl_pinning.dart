// import 'package:ssl_pinning_plugin/ssl_pinning_plugin.dart';

// class SslPinningHelper {

//   Future<bool> isSecure(String url, HttpMethod httpMethod) async {
//     try {
//       bool checked = false;
//       String fingerprint = 'E0 F6 90 BB E9 D9 51 8A 42 A6 84 02 D8 7F 44 85 EC 38 F8 A3 D3 4D 90 5F EE F7 2C D7 FB B9 52 08';
//       List<String> allowedShA256FingerprintList = [fingerprint];
//       var uri = Uri.parse(url);
//       String status = await SslPinningPlugin.check(
//         serverURL: uri.toString(),
//         headerHttp: {},
//         httpMethod: httpMethod,
//         sha: SHA.SHA256,
//         allowedSHAFingerprints: allowedShA256FingerprintList,
//         timeout: 100,
//       );
//       if (status == "CONNECTION_SECURE") {
//         checked = true;
//       }
//       return checked;
//     } catch (error) {
//       print('SSL Pinning Error $error');
//       return false;
//     }

    // bool secure = false;
    // String fingerprint = "60 DD F6 CA 48 50 EC 0F 4B B6 96 0C 1F C4 3E 2B D3 B3 5E 6D";
    // List<String> allowedSHAFingerprints = [];
    // allowedSHAFingerprints.add(fingerprint);
    // var uri = Uri.parse(url);
    // try {
    //   String message = await SslPinningPlugin.check(
    //       serverURL: uri.toString(),
    //       sha: SHA.SHA1,
    //       allowedSHAFingerprints: allowedSHAFingerprints,
    //       timeout: 60
    //   );
    //   if (message == 'CONNECTION_SECURE') {
    //     secure = true;
    //   } else {
    //     secure = false;
    //   }
    // } catch (e) {
    //   secure = false;
    // }
    // return secure;
  // }
// }