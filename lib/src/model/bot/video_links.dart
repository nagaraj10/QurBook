class VideoLinks {
  String title;
  String thumbnail;
  String url;

  VideoLinks({this.title, this.thumbnail, this.url});

  VideoLinks.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    thumbnail = json['thumbnail'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['thumbnail'] = this.thumbnail;
    data['url'] = this.url;
    return data;
  }
}