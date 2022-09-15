import 'package:flutter/material.dart';
import 'package:myfhb/common/PreferenceUtil.dart';

Radius chatCircularRadius() {
  return const Radius.circular(25);
}

BorderRadius chatBubbleBorderRadiusFor(bool sender) {
  return BorderRadius.only(
    topRight: sender
        ? PreferenceUtil.getIfQurhomeisAcive()
            ? chatCircularRadius()
            : Radius.zero
        : chatCircularRadius(),
    topLeft: sender
        ? chatCircularRadius()
        : PreferenceUtil.getIfQurhomeisAcive()
            ? chatCircularRadius()
            : Radius.zero,
    bottomLeft: sender
        ? chatCircularRadius()
        : PreferenceUtil.getIfQurhomeisAcive()
            ? Radius.zero
            : chatCircularRadius(),
    bottomRight: sender
        ? PreferenceUtil.getIfQurhomeisAcive()
            ? Radius.zero
            : chatCircularRadius()
        : chatCircularRadius(),
  );
}
