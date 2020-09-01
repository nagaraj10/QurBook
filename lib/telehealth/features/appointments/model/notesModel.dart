class Notes {
  Notes({
    this.mediaMetaId,
  });

  String mediaMetaId;

  Notes.fromJson(Map<String, dynamic> json) {
    mediaMetaId = json["mediaMetaId"]==null?null:json["mediaMetaId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    {
      data["mediaMetaId"] = this.mediaMetaId;
      return data;
    }
  }
}