import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myeuc_x_supabase/shared/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutDevelopersScreen extends StatelessWidget {
  const AboutDevelopersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("Developers"),
        backgroundColor: MAROON,
        foregroundColor: Colors.white,
      ),

      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DeveloperCard(
              name: "Gabriel Santoc",
              department: "Computer Science",
              imageLink: 'assets/about_dev/gabrielSantoc.jpg',
              socials: [
                SocialLink(icon: FontAwesomeIcons.envelope, url: 'gabrielsantoc05@gmail.com'),
                SocialLink(icon: FontAwesomeIcons.github, url: 'https://github.com/gabrielSantoc'),
              ]
            ),

            SizedBox(height: 35),

            DeveloperCard(
              name: "Mark Joshua Tarcelo",
              department: "Computer Science",
              imageLink: 'assets/about_dev/markJoshua.jpg',
              socials: [
                SocialLink(icon: FontAwesomeIcons.envelope, url: 'markjoshuatarcelo@gmail.com'),
                SocialLink(icon: FontAwesomeIcons.github, url: 'https://github.com/MarkJoshua23'),
              ]
            ),




          ],
        ),
      )
    ); 
  }
}

class SocialLink {
  final IconData icon;
  final String url;
  const SocialLink({required this.icon, required this.url});
}


class DeveloperCard extends StatelessWidget {
  const DeveloperCard({
    super.key,
    required this.name,
    required this.department,
    required this.imageLink,
    required this.socials
  });

  final String name;
  final String department;
  final String imageLink;
  final List<SocialLink> socials;


  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage(imageLink),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
            // const SizedBox(height: 10),
            Text(
              department,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600]
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: socials.map((social) => 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: IconButton(

                    onPressed: () async {
                      String? encodeQueryParameters(Map<String, String> params) {
                        return params.entries.map(
                          (MapEntry<String, String> e) =>
                          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}'
                        )
                        .join('&');
                      }

                      final Uri _url = Uri.parse(social.url);

                      if (_url.scheme == 'http' || _url.scheme == 'https') {
                        await launchUrl(_url);
                        return;
                      }


                      if (social.url.contains('@')) {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: social.url,
                          query: encodeQueryParameters(<String, String>{
                            'subject': 'Hello, myEUC Team!',
                          }),
                        );

                        await launchUrl(emailLaunchUri);
                      }
                    },
                    icon: FaIcon(social.icon, color: Colors.black)
                  ),
                )
              ).toList(),
            )
            

          ],
        ),
      );
  }
}