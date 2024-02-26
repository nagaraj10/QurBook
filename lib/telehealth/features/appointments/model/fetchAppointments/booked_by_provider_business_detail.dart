
class BookedByProviderBusinessDetail {
  List<dynamic>? documents;
  String? gstNumber;
  String? referralCode;

  BookedByProviderBusinessDetail({
    this.documents,
    this.gstNumber,
    this.referralCode,
  });

  factory BookedByProviderBusinessDetail.fromJson(Map<String, dynamic> json) =>
      BookedByProviderBusinessDetail(
        documents: json['documents'] == null
            ? []
            : List<dynamic>.from(json['documents']!.map((x) => x)),
        gstNumber: json['gstNumber'],
        referralCode: json['referralCode']!,
      );

  Map<String, dynamic> toJson() => {
        'documents': documents == null
            ? []
            : List<dynamic>.from(documents!.map((x) => x)),
        'gstNumber': gstNumber,
        'referralCode': referralCode,
      };
}
