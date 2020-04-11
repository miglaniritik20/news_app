class News {
  final int id;
  final String title;
  final String description;
  final String url;
  final String imglink;
  final String published;

  News(this.id, this.title, this.description, this.url, this.imglink,
      this.published);

  factory News.fromJson(dynamic json) {
    return News(
        json['id'] as int,
        json['title'] as String,
        json['description'] as String,
        json['url'] as String,
        json['imglink'] as String,
        json['published'] as String);
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'url': url,
        'imglink': imglink,
        'published': published
      };

  @override
  String toString() {
    return '{${this.id},${this.title},${this.description},${this.url},${this.imglink},${this.published}';
  }
}
