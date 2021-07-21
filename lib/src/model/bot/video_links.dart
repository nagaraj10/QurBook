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
    final data = <String, dynamic>{};
    data['title'] = title;
    data['thumbnail'] = thumbnail;
    data['url'] = url;
    return data;
  }
}