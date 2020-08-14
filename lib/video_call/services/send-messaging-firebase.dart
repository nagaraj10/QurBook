import 'package:http/http.dart' as http;

const String fcmServerKey =
    'Bearer AAAACZiO6Jc:APA91bGLUxie3uFmCwjF-H7W2yBnMZ4mFiRPIkj1n9CGbAlSYFzvy3WpN7lBAr1ib8jLC1oo7EJRh96fm9i82DSVNxtSo3P2xbZC0-iCqP-1qInpq5xCg9KV203Ad7G4QbkfNeUNpz-P';

class SendMessaging {
  Future<void> sendMessage(String token, String data) async {
    final http.Response response = await http
        .post("https://fcm.googleapis.com/fcm/send", body: data, headers: {
      "Content-Type": "application/json",
      "Authorization": "key=\"$fcmServerKey\""
    });
    if (response.statusCode == 201 || response.statusCode == 200) {
      print(response);
    } else {
      print(response.body);
      print("Failed send message");
    }
  }
}
