import 'package:flutter/material.dart';
import 'package:healthcare/utilities/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Health News",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 3),
      body: FutureBuilder<List<News>>(
        future: ApiCalls().fetchHealthNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading news.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No news articles found.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              ),
            );
          }
          else{
            final newsList = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                News article = newsList[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // InkWell widget instead of GestureDetector for visuals
                  // Suggested by Gemini AI
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      if (article.articleUrl.isNotEmpty) {
                        launchURL(article.articleUrl);
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (article.imageUrl.isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.network(
                              article.imageUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              // errorBuilder to collapse space to zero if theres image error
                              // Suggested by Gemini AI
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
                                  Icon(Icons.newspaper_rounded,
                                    color: AppColors.primary, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      article.sourceName,
                                      style: TextStyle(
                                        color: AppColors.primary,
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
                                article.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: AppColors.textPrimary,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    article.publishedDate,
                                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Read Article',
                                        style: TextStyle(color: AppColors.primary,
                                          fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(Icons.open_in_new_rounded, size: 14,
                                        color: AppColors.primary)
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
          }
        },
      ),
    );
  }
}