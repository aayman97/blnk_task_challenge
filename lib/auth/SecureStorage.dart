import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth_io.dart';

class SecureStorage {
  final storage = FlutterSecureStorage();

  // AccessToken a = AccessToken(
  //     "Bearer",
  //     "ya29.A0ARrdaM-FLtrnCz6OfGf6uKZnnyXljF9X0xMeUqc5-2W7DLDgTlaS_HuZ-eO4SUHkfXdY4A7y_2WOA8ePfE1yehfqQQizt7HaEunpNWf1oewu1AvrtBSSlm7nsxFrSblLMvF0vgJPH_bnlyarDob2Hb4k-D5f",
  //     DateTime.utc(
  //         DateTime.now().year,
  //         DateTime.now().month,
  //         DateTime.now().day,
  //         DateTime.now().hour,
  //         DateTime.now().minute,
  //         DateTime.now().second,
  //         DateTime.now().millisecond,
  //         DateTime.now().microsecond));

  //Save Credentials
  Future saveCredentials(AccessToken token, String refreshToken) async {
    print(token.expiry.toIso8601String());
    await storage.write(key: "type", value: token.type);
    await storage.write(key: "data", value: token.data);
    await storage.write(key: "expiry", value: token.expiry.toString());
    await storage.write(key: "refreshToken", value: refreshToken);
  }

  //Get Saved Credentials
  Future<Map<String, dynamic>?> getCredentials() async {
    var result = await storage.readAll();
    if (result.isEmpty) return null;
    return result;
  }

  //Clear Saved Credentials
  Future clear() {
    return storage.deleteAll();
  }
}
