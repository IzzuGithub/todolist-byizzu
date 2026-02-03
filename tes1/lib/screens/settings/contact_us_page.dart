import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);
  void _launchURL(String url) async { if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url'; }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Contact Us"), backgroundColor: Colors.white, foregroundColor: Colors.black), body: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
      Card(elevation: 4, margin: const EdgeInsets.only(bottom: 15), child: ListTile(leading: const Icon(Icons.chat, color: Colors.green), title: const Text("WhatsApp"), subtitle: const Text("082331362037"), onTap: () => _launchURL("https://wa.me/6282331362037"))),
      Card(elevation: 4, margin: const EdgeInsets.only(bottom: 15), child: ListTile(leading: const Icon(Icons.camera_alt, color: Colors.purple), title: const Text("Instagram"), subtitle: const Text("@rozaky.06"), onTap: () => _launchURL("https://instagram.com/rozaky.06"))),
    ])));
  }
}