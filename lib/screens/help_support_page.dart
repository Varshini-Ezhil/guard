import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';
import 'package:easy_localization/easy_localization.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@fertilefuture.com',
      queryParameters: {
        'subject': 'Support Request - Fertile Future App',
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch email';
    }
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    } else {
      throw 'Could not launch phone';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Help & Support', style: TextStyle(color: Colors.white)),
        backgroundColor: kPrimaryGreen,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kPrimaryGreen.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Us',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryGreen,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'We\'re here to help! Reach out to us through any of the following channels:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.email, color: kPrimaryGreen),
                      title: const Text(
                        'Email Support',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: const Text('support@fertilefuture.com'),
                      onTap: _launchEmail,
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.phone, color: kPrimaryGreen),
                      title: const Text(
                        'Call Us',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: const Text('Monday to Friday, 9 AM - 6 PM'),
                      trailing: ElevatedButton(
                        onPressed: () => _launchPhone('+1234567890'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Call Now'),
                      ),
                    ),
                    const Divider(height: 1),
                    const ListTile(
                      leading:
                          Icon(Icons.location_on, color: kPrimaryGreen),
                      title: Text(
                        'Office Address',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        '123 Agriculture Street\nFarm City, FC 12345\nCountry',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FAQs',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryGreen,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Find quick answers to common questions',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.question_answer,
                          color: kPrimaryGreen),
                      title: const Text(
                        'View FAQs',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // Navigate to FAQs page
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
