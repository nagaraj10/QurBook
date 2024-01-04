import '../../my_family/models/FamilyMembersRes.dart';
import '../../my_family/models/relationships.dart';

class VoiceCloneSharedByUsers extends SharedByUsers {
  bool isSelected = false;

  VoiceCloneSharedByUsers({
    required this.isSelected,
    String? id,
    String? status,
    String? nickName,
    bool? isActive,
    String? createdOn,
    String? lastModifiedOn,
    RelationsShipModel? relationship,
    Child? child,
    String? membershipOfferedBy,
    bool? isCaregiver,
    bool? isNewUser,
    String? remainderForId,
    String? remainderFor,
    String? remainderMins,
    String? nonAdheranceId,
    ChatListItem? chatListItem,
    String? nickNameSelf,
  }) : super(
          id: id,
          status: status,
          nickName: nickName,
          isActive: isActive,
          createdOn: createdOn,
          lastModifiedOn: lastModifiedOn,
          relationship: relationship,
          child: child,
          membershipOfferedBy: membershipOfferedBy,
          isCaregiver: isCaregiver,
          isNewUser: isNewUser,
          remainderForId: remainderForId,
          remainderFor: remainderFor,
          remainderMins: remainderMins,
          nonAdheranceId: nonAdheranceId,
          chatListItem: chatListItem,
          nickNameSelf: nickNameSelf,
        );

  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['isSelected'] = isSelected;
    return data;
  }

  VoiceCloneSharedByUsers.fromJson(Map<String, dynamic> json)
      : isSelected = json['isSelected'] ?? false,
        super.fromJson(json);
}
