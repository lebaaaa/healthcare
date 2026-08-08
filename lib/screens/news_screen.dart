import 'package:flutter/material.dart';
import 'package:healthcare/utilities/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utilities/api_calls.dart';
import '../widgets/navigation_bar.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  Future<void> launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Health News",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.Primary,
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 3),
      body: FutureBuilder<List<dynamic>>(
        future: ApiCalls().fetchHealthNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading news.\nCheck your console for details.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No news articles found.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
              ),
            );
          }

          final newsList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(20.0),
            itemCount: newsList.length,
            itemBuilder: (context, index) {
              final article = newsList[index];

              // 1. Extract the title
              final title = article['title'] ?? 'No Title Available';

              // 2. Extract the source name based on your JSON structure
              final source = article['source_name'] ?? 'Unknown Source';

              // 3. Extract the image URL
              final imageUrl = article['photo_url'] ?? '';

              // 4. Extract the article link
              final articleUrl = article['link'] ?? '';

              // 5. Extract date
              final published = article['published_datetime_utc'] ?? '';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                // InkWell makes the card tappable with a nice ripple effect
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    if (articleUrl.isNotEmpty) {
                      launchURL(articleUrl);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Render image if URL exists
                      if (imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            imageUrl,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            // If the image fails to load, collapse the space
                            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.newspaper_rounded, color: Colors.teal.shade700, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    source,
                                    style: TextStyle(
                                      color: Colors.teal.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF1E293B),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDate(published),
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Read Article',
                                      style: TextStyle(color: Colors.teal.shade700, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(Icons.open_in_new_rounded, size: 14, color: Colors.teal.shade700)
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Helper method to make the UTC date string look cleaner
  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString.split(' ').first; // Fallback to just grabbing the first part of the string
    }
  }
}