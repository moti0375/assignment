import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

abstract class ShareCenter {
  Future<void> share({required String text, String? subject = null});

  void shareOnWhatsapp(String text, String url);
}

class ShareCenterImpl implements ShareCenter {
  @override
  Future<void> share({required String text, String? subject}) async {
    return Share.share(text, subject: subject);
  }

  @override
  Future<void> shareOnWhatsapp(String text, String url) async {
    if (Platform.isAndroid) {
      WhatsappShare.isInstalled().then((value) {
        if (value == true) {
          WhatsappShare.share(phone: "*1234", text: text, linkUrl: url);
        }
      });
    } else {
      WhatsappShare.share(phone: "*1234", text: text, linkUrl: url);
    }
  }
}
