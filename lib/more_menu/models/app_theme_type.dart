import '../../constants/variable_constant.dart' as variable;

enum EnumAppThemeType {
  Modern,
  Classic;

  static EnumAppThemeType fromName(String name) {
    for (EnumAppThemeType enumVariant in EnumAppThemeType.values) {
      if (enumVariant.name == name) return enumVariant;
    }
    return EnumAppThemeType.Classic;
  }
}

extension ParseToString on EnumAppThemeType {
  String toShortString() {
    switch (this) {
      case EnumAppThemeType.Classic:
      return variable.strAppThemeClassic;
      case EnumAppThemeType.Modern:
      return variable.strAppThemeModern;
      
    }
  }
}