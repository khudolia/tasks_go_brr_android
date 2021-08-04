import 'package:url_launcher/url_launcher.dart';

class Links {
  static Future openLink(String url) async {
    if (await canLaunch(url))
      return launch(url);
    else
      throw "Could not launch $url";
  }
}