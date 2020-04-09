class DescriptionData{
  String title;
  String desc;
  String publish;
  String imgURL;
  String userName;
  String firstName;
  String lastName;

  DescriptionData(this.title, this.desc, this.publish,this.imgURL, this.userName,this.firstName,this.lastName);

  factory DescriptionData.fromJson(dynamic json){
    return DescriptionData(
      json['title'] as String,
      json['description'] as String,
      json['published'] as String,
      json['featured_image'] as String,
      json['author']['username'] as String,
      json['author']['first_name'] as String,
      json['author']['last_name'] as String,
      
    );
  }


  @override
  String toString() {
    return '{ ${this.title}, ${this.desc}, ${this.publish}, ${this.imgURL}, ${this.userName}, ${this.firstName}, ${this.lastName} }';
  }
}
