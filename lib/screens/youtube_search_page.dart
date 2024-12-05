import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart'; // for kPrimaryGreen
import 'package:easy_localization/easy_localization.dart';

class YouTubeSearchPage extends StatefulWidget {
  const YouTubeSearchPage({super.key});

  @override
  State<YouTubeSearchPage> createState() => _YouTubeSearchPageState();
}

class _YouTubeSearchPageState extends State<YouTubeSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];
  bool isLoading = false;
  final String apiKey = 'AIzaSyD8ycG4ci7pqYAsH2grz0aUQS58KP22VQM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('youtubeVideos'.tr()),
        backgroundColor: kPrimaryGreen,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: _searchYouTube,
              decoration: InputDecoration(
                hintText: 'searchFarmingVideos'.tr(), // Make sure this exact key is used
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchYouTube(_searchController.text),
                ),
              ),
            ),
          ),
          if (isLoading)
            const CircularProgressIndicator()
          else
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final parts = searchResults[index].split('|');
                  final url = parts[0];
                  final title = parts[1];
                  return ListTile(
                    leading: const Icon(Icons.play_circle_filled),
                    title: Text(title),
                    onTap: () async {
                      final Uri uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('couldNotOpenVideo'.tr())),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _searchYouTube(String query) async {
    if (query.isEmpty) return;
    setState(() {
      isLoading = true;
    });

    try {
      final searchQuery = Uri.encodeComponent('$query farming agriculture');
      final url =
          'https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=$searchQuery&type=video&key=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          searchResults = (data['items'] as List).map((item) {
            final videoId = item['id']['videoId'];
            final title = item['snippet']['title'];
            return 'https://www.youtube.com/watch?v=$videoId|$title';
          }).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
