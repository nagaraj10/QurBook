import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'dart:convert';

class FieldsResponseModel {
  FieldsResponseModel({
    this.isSuccess,
    this.result,
  });

  final bool isSuccess;
  final ResultDataModel result;

  factory FieldsResponseModel.fromJson(Map<String, dynamic> json) =>
      FieldsResponseModel(
        isSuccess: json['isSuccess'],
        result: ResultDataModel.fromJson(json['result']),
      );

  Map<String, dynamic> toJson() => {
        'isSuccess': isSuccess,
        'result': result.toJson(),
      };
}

class ResultDataModel {
  ResultDataModel({
    this.row,
    this.fields,
    this.value,
  });

  final RowModel row;
  final List<FieldModel> fields;
  final ValueModel value;

  factory ResultDataModel.fromJson(Map<String, dynamic> json) =>
      ResultDataModel(
        row: RowModel.fromJson(json['row']),
        fields: List<FieldModel>.from(
            json['fields'].map((x) => FieldModel.fromJson(x))),
        value: ValueModel.fromJson(json['value'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'row': row.toJson(),
        'fields': List<dynamic>.from(fields.map((x) => x.toJson())),
        'value': value.toJson(),
      };
}

class FieldModel {
  FieldModel({
    this.fieldid,
    this.providerid,
    this.formid,
    this.title,
    this.description,
    this.uomid,
    this.fdata,
    this.ftype,
    this.vmin,
    this.vmax,
    this.amin,
    this.amax,
    this.validation,
    this.seq,
    this.depth,
    this.ts,
    this.deleted,
    this.value,
  });

  String fieldid;
  String providerid;
  String formid;
  String title;
  String description;
  String uomid;
  String fdata;
  FieldType ftype;
  String vmin;
  String vmax;
  String amin;
  String amax;
  dynamic validation;
  String seq;
  String depth;
  DateTime ts;
  String deleted;
  String value;

  factory FieldModel.fromJson(Map<String, dynamic> json) => FieldModel(
        fieldid: json['fieldid'],
        providerid: json['providerid'],
        formid: json['formid'],
        title: json['title'],
        description: json['description'],
        uomid: json['uomid'],
        fdata: json['fdata'],
        ftype: fieldTypeValues.map[json['ftype'].toString().toLowerCase()],
        vmin: json['vmin'],
        vmax: json['vmax'],
        amin: json['amin'],
        amax: json['amax'],
        validation: json['validation'],
        seq: json['seq'],
        depth: json['depth'],
        ts: DateTime.tryParse(json['ts'] ?? ''),
        deleted: json['deleted'],
      );

  Map<String, dynamic> toJson() => {
        'fieldid': fieldid,
        'providerid': providerid,
        'formid': formid,
        'title': title,
        'description': description,
        'uomid': uomid,
        'fdata': fdata,
        'ftype': ftype,
        'vmin': vmin,
        'vmax': vmax,
        'amin': amin,
        'amax': amax,
        'validation': validation,
        'seq': seq,
        'depth': depth,
        'ts': ts.toIso8601String(),
        'deleted': deleted,
      };
}

class RowModel {
  RowModel({
    this.teidUser,
    this.custform,
    this.uformid,
    this.uformdata,
    this.providerid,
    this.providername,
  });

  final String teidUser;
  final dynamic custform;
  final String uformid;
  final UformData uformdata;
  final String providerid;
  final String providername;

  factory RowModel.fromJson(Map<String, dynamic> json) => RowModel(
        teidUser: json['teid_user'],
        custform: json['custform'],
        uformid: json['uformid'],
        uformdata: UformData().fromJson(jsonDecode(json["uformdata"] ?? '{}')),
        providerid: json['providerid'],
        providername: json['providername'],
      );

  Map<String, dynamic> toJson() => {
        'teid_user': teidUser,
        'custform': custform,
        'uformid': uformid,
        'uformdata': uformdata,
        'providerid': providerid,
        'providername': providername,
      };
}

class ValueModel {
  ValueModel({
    this.systolic,
    this.diastolic,
    this.pulse,
    this.check,
    this.radio,
    this.otherdata,
  });

  final VitalsData systolic;
  final VitalsData diastolic;
  final VitalsData pulse;
  final VitalsData check;
  final VitalsData radio;
  final Otherdata otherdata;

  factory ValueModel.fromJson(Map<String, dynamic> json) => ValueModel(
        systolic: VitalsData.fromJson(json['Systolic'] ?? {}),
        diastolic: VitalsData.fromJson(json['Diastolic'] ?? {}),
        pulse: VitalsData.fromJson(json['Pulse'] ?? {}),
        check: VitalsData.fromJson(json['check'] ?? {}),
        radio: VitalsData.fromJson(json['Radio'] ?? {}),
        otherdata: Otherdata.fromJson(json['#otherdata'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'Systolic': systolic.toJson(),
        'Diastolic': diastolic.toJson(),
        'Pulse': pulse.toJson(),
        'check': check.toJson(),
        'Radio': radio.toJson(),
        '#otherdata': otherdata.toJson(),
      };
}

class Otherdata {
  Otherdata({
    this.photo,
    this.audio,
    this.file,
    this.video,
  });

  final MediaModel photo;
  final MediaModel audio;
  final MediaModel file;
  final MediaModel video;

  factory Otherdata.fromJson(Map<String, dynamic> json) => Otherdata(
        photo: MediaModel.fromJson(json['PHOTO'] ?? {}),
        audio: MediaModel.fromJson(json['AUDIO'] ?? {}),
        file: MediaModel.fromJson(json['FILE'] ?? {}),
        video: MediaModel.fromJson(json['VIDEO'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'PHOTO': photo.toJson(),
        'AUDIO': audio.toJson(),
        'FILE': file.toJson(),
        'VIDEO': video.toJson(),
      };
}

class MediaModel {
  MediaModel({
    this.name,
    this.url,
  });

  final String name;
  final String url;

  factory MediaModel.fromJson(Map<String, dynamic> json) => MediaModel(
        name: json['name'],
        url: json['url'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
      };
}
