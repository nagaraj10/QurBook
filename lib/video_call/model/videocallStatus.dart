class VideoCallStatus {
  VideoCallStatus({
    this.acceptedByWeb,
    this.videoRequestFromMobile,
    this.acceptedByMobile,
    this.videoRequestFromWeb,
  });

  int acceptedByWeb = -1;
  int videoRequestFromMobile = -1;
  int acceptedByMobile = -1;
  int videoRequestFromWeb = -1;

  factory VideoCallStatus.fromMap(Map<String, dynamic> json) => VideoCallStatus(
        acceptedByWeb: json["acceptedByWeb"] ?? -1,
        videoRequestFromMobile: json["videoRequestFromMobile"],
        acceptedByMobile: json["acceptedByMobile"],
        videoRequestFromWeb: json["videoRequestFromWeb"],
      );
  setDefaultValues() {
    acceptedByWeb = -1;
    acceptedByMobile = -1;
    videoRequestFromMobile = -1;
    videoRequestFromWeb = -1;
  }

  Map<String, dynamic> toMap({withCallStatus = false}) => {
        "acceptedByWeb": acceptedByWeb,
        "videoRequestFromMobile": videoRequestFromMobile,
        "acceptedByMobile": acceptedByMobile,
        "videoRequestFromWeb": videoRequestFromWeb,
      };
}
