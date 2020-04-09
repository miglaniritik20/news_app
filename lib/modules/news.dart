class News{

  final String title;
  final String description;
  final String url;
  final String imglink;
  final String published;

  News(
    this.title,
    this.description,
    this.url,
    this.imglink,
    this.published
  );

  factory News.fromJson(dynamic json){
    return News(
      json['title'] as String,
      json['description'] as String,
      json['url'] as String,
      json['imglink'] as String,
      json['published'] as String
    );
  }

  @override
  String toString(){
    return '{${this.title},${this.description},${this.url},${this.imglink},${this.published}';
  }
}