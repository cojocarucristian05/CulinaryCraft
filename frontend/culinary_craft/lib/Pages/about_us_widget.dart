import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsWidget extends StatelessWidget {
  final String imageUrl1 = 'assets/images/Cristian.jpeg';
  final String imageUrl2 = 'assets/images/Mihai.jpg';
  final String iconUrl = 'assets/images/icon2.png';

  final String linkedinUrl1 = 'https://www.linkedin.com/in/cristian-cojocaru-380551255/';
  final String gmailUrl1 = 'mailto:cojocaru.cristian20@gmail.com';

  final String linkedinUrl2 = 'https://www.linkedin.com/in/mihai-cebuc-895aa0256/';
  final String gmailUrl2 = 'mailto:mihaicebuc36@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Container(
        color: Colors.white, // Setează fundalul în alb
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Afișează conținutul de la început
            children: [
              SizedBox(height: 20), // Adaugă un spațiu gol deasupra imaginii
              Image.asset(
                iconUrl,
                width: 300,
                height: 300,
              ),
              Spacer(), // Adaugă un spațiu flexibil pentru a împinge restul conținutului mai jos
              _buildCreatorInfo(
                imageUrl: imageUrl1,
                linkedinUrl: linkedinUrl1,
                gmailUrl: gmailUrl1,
                name: 'Cristian Cojocaru',
              ),
              SizedBox(height: 32),
              _buildCreatorInfo(
                imageUrl: imageUrl2,
                linkedinUrl: linkedinUrl2,
                gmailUrl: gmailUrl2,
                name: 'Mihai Cebuc',
              ),
              Spacer(), // Adaugă un spațiu flexibil pentru a împinge restul conținutului mai jos
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreatorInfo({
    required String imageUrl,
    required String linkedinUrl,
    required String gmailUrl,
    required String name,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50), // Rotunjim marginile
          child: Image.asset(
            imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.linkedin,
                    size: 30,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        debugPrint('LinkedIn link tapped: $linkedinUrl');
                        _launchURL(linkedinUrl);
                      },
                      child: Text(
                        linkedinUrl,
                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.envelope,
                    size: 30,
                    color: Colors.red,
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: GestureDetector(
                      child: Text(
                        gmailUrl.replaceAll('mailto:', ''),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint('Could not launch $url');
      throw 'Could not launch $url';
    }
  }
}
