class NewsResponseModel {
  final List<NewsModel> news;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  NewsResponseModel({
    required this.news,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) {
    return NewsResponseModel(
      news: (json['news'] as List)
          .map((item) => NewsModel.fromJson(item))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'news': news.map((item) => item.toJson()).toList(),
      'total': total,
      'page': page,
      'pageSize': pageSize,
      'totalPages': totalPages,
    };
  }
}

class NewsModel {
  final String id;
  final String title;
  final String shortDescription;
  final String thumbnail;
  final DateTime publishedAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.thumbnail,
    required this.publishedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      shortDescription: json['shortDescription'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'shortDescription': shortDescription,
      'thumbnail': thumbnail,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }
}
