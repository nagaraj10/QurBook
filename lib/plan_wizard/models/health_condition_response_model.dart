import 'dart:convert';

class HealthConditionResponseModel {
  HealthConditionResponseModel({
    this.isSuccess,
    this.healthConditionData,
  });

  final bool isSuccess;
  final HealthConditionModel healthConditionData;

  factory HealthConditionResponseModel.fromJson(Map<String, dynamic> json) =>
      HealthConditionResponseModel(
        isSuccess: json['isSuccess'] ?? false,
        healthConditionData:
            HealthConditionModel.fromJson(json['result'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'isSuccess': isSuccess,
        'result': healthConditionData.toJson(),
      };
}

class HealthConditionModel {
  HealthConditionModel({
    this.menuitems,
    this.isFinal,
    this.tagHistory,
    this.tags,
    this.menustate,
  });

  final List<MenuItem> menuitems;
  final int isFinal;
  final String tagHistory;
  final String tags;
  final String menustate;

  factory HealthConditionModel.fromJson(Map<String, dynamic> json) =>
      HealthConditionModel(
        menuitems: json['menuitems'] != null
            ? List<MenuItem>.from(
                json['menuitems']?.map((x) => MenuItem.fromJson(x ?? {})))
            : null,
        isFinal: json['isFinal'],
        tagHistory: json['tag_history'],
        tags: json['tags'],
        menustate: json['menustate'],
      );

  Map<String, dynamic> toJson() => {
        'menuitems': List<dynamic>.from(menuitems.map((x) => x.toJson())),
        'isFinal': isFinal,
        'tag_history': tagHistory,
        'tags': tags,
        'menustate': menustate,
      };
}

class MenuItem {
  MenuItem({
    this.menuid,
    this.menulistid,
    this.uid,
    this.providerid,
    this.menucatid,
    this.title,
    this.description,
    this.tags,
    this.menuitemtype,
    this.groupname,
    this.submenu,
    this.metadata,
    this.ts,
    this.seq,
    this.depth,
    this.deleted,
    this.menulisttype,
    this.menunavtype,
  });

  final String menuid;
  final String menulistid;
  final String uid;
  final String providerid;
  final String menucatid;
  final String title;
  final Description description;
  final String tags;
  final Menuitemtype menuitemtype;
  final String groupname;
  final Submenu submenu;
  final Metadata metadata;
  final DateTime ts;
  final String seq;
  final String depth;
  final String deleted;
  final String menulisttype;
  final String menunavtype;

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
        menuid: json['menuid'],
        menulistid: json['menulistid'],
        uid: json['uid'],
        providerid: json['providerid'],
        menucatid: json['menucatid'],
        title: json['title'],
        description: descriptionValues.map[json['description']],
        tags: json['tags'],
        menuitemtype: menuitemtypeValues.map[json['menuitemtype']],
        groupname: json['groupname'],
        submenu: submenuValues.map[json['submenu']],
        metadata:
            json['metadata'] != null && json['metadata'].toString().isNotEmpty
                ? Metadata.fromJson(jsonDecode(json['metadata'] ?? '{}'))
                : null,
        ts: DateTime.parse(json['ts']),
        seq: json['seq'],
        depth: json['depth'],
        deleted: json['deleted'],
        menulisttype: json['menulisttype'],
        menunavtype: json['menunavtype'],
      );

  Map<String, dynamic> toJson() => {
        'menuid': menuid,
        'menulistid': menulistid,
        'uid': uid,
        'providerid': providerid,
        'menucatid': menucatid,
        'title': title,
        'description': descriptionValues.reverse[description],
        'tags': tags,
        'menuitemtype': menuitemtypeValues.reverse[menuitemtype],
        'groupname': groupname,
        'submenu': submenuValues.reverse[submenu],
        'metadata': metadata?.toJson(),
        'ts': ts.toIso8601String(),
        'seq': seq,
        'depth': depth,
        'deleted': deleted,
        'menulisttype': menulisttype,
        'menunavtype': menunavtype,
      };
}

class Metadata {
  Metadata({
    this.icon,
    this.color,
    this.bgcolor,
    this.metadatafrom,
  });

  final String icon;
  final String color;
  final String bgcolor;
  final String metadatafrom;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        icon: json['icon'],
        color: json['color'],
        bgcolor: json['bgcolor'],
        metadatafrom: json['metadatafrom'],
      );

  Map<String, dynamic> toJson() => {
        'icon': icon,
        'color': color,
        'bgcolor': bgcolor,
        'metadatafrom': metadatafrom,
      };
}

enum Description { DESCRIPTION1, DESCRIPTION3, FULL_MENU_DESCRIPTION3 }

final descriptionValues = EnumValues({
  'description1': Description.DESCRIPTION1,
  'description3': Description.DESCRIPTION3,
  'FullMenu description3': Description.FULL_MENU_DESCRIPTION3
});

enum Menuitemtype { SEPERATOR, CHECKBOX, SUBMENU }

final menuitemtypeValues = EnumValues({
  'checkbox': Menuitemtype.CHECKBOX,
  'seperator': Menuitemtype.SEPERATOR,
  'submenu': Menuitemtype.SUBMENU
});

enum Submenu { EMPTY, FULL_MENU }

final submenuValues =
    EnumValues({'': Submenu.EMPTY, 'FullMenu': Submenu.FULL_MENU});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
