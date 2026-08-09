class News {
  final String title;
  final String sourceName;
  final String imageUrl;
  final String articleUrl;
  final String publishedDate;

  News({
    required this.title,
    required this.sourceName,
    required this.imageUrl,
    required this.articleUrl,
    required this.publishedDate,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    // Helper to format the date right as it's parsed
    String formatDate(String dateString) {
      if (dateString.isEmpty) return '';
      try {
        final date = DateTime.parse(dateString);
        return "${date.day}/${date.month}/${date.year}";
      } catch (e) {
        return dateString.split(' ').first;
      }
    }

    return News(
      title: json['title'] ?? 'No Title Available',
      sourceName: json['source_name'] ?? 'Unknown Source',
      imageUrl: json['photo_url'] ?? '',
      articleUrl: json['link'] ?? '',
      publishedDate: formatDate(json['published_datetime_utc'] ?? ''),
    );
  }
}