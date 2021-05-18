import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myfhb/regiment/view_model/regiment_view_model.dart';
import 'package:myfhb/src/utils/screenutils/size_extensions.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'widgets/regiment_data_card.dart';
import 'package:myfhb/regiment/models/regiment_data_model.dart';
import 'package:intl/intl.dart';
import 'package:myfhb/constants/fhb_constants.dart';
import 'package:myfhb/regiment/models/profile_response_model.dart';
import 'package:myfhb/regiment/view/widgets/event_list_widget.dart';
import 'package:myfhb/src/ui/bot/viewmodel/chatscreen_vm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myfhb/telehealth/features/SearchWidget/view/SearchWidget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegimentTab extends StatefulWidget {
  @override
  _RegimentTabState createState() => _RegimentTabState();
}

class _RegimentTabState extends State<RegimentTab> with WidgetsBindingObserver {
  RegimentViewModel _regimentViewModel;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  final scrollController =
      AutoScrollController(axis: Axis.vertical, suggestedRowHeight: 150);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<RegimentViewModel>(
      context,
      listen: false,
    ).updateTabIndex(currentIndex: 0);
    Provider.of<ChatScreenViewModel>(context, listen: false)?.updateAppState(
      true,
      isInitial: true,
    );
    Provider.of<RegimentViewModel>(context, listen: false).resetRegimenTab();
    Provider.of<RegimentViewModel>(context, listen: false).fetchRegimentData(
      isInitial: true,
    );
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      Provider.of<ChatScreenViewModel>(context, listen: false)
          .updateAppState(false);
    } else if (state == AppLifecycleState.resumed) {
      Provider.of<ChatScreenViewModel>(context, listen: false)
          .updateAppState(true);
    }
  }

  @override
  void dispose() {
    searchController?.dispose();
    scrollController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Color getColor(
      Activityname activityname, Uformname uformName, Metadata metadata) {
    Color cardColor;
    try {
      if ((metadata?.color?.length ?? 0) == 7) {
        cardColor = Color(int.parse(metadata?.color.replaceFirst('#', '0xFF')));
      } else {
        switch (activityname) {
          case Activityname.DIET:
            cardColor = Colors.green;
            break;
          case Activityname.VITALS:
            if (uformName == Uformname.BLOODPRESSURE) {
              cardColor = Color(0xFF059192);
            } else if (uformName == Uformname.BLOODSUGAR) {
              cardColor = Color(0xFFb70a80);
            } else if (uformName == Uformname.PULSE) {
              cardColor = Color(0xFF8600bd);
            } else {
              cardColor = Colors.lightBlueAccent;
            }
            break;
          case Activityname.MEDICATION:
            cardColor = Colors.blue;
            break;
          case Activityname.SCREENING:
            cardColor = Colors.teal;
            break;
          default:
            cardColor = Color(CommonUtil().getMyPrimaryColor());
        }
      }
    } catch (e) {
      cardColor = Color(CommonUtil().getMyPrimaryColor());
    }
    return cardColor;
  }

  dynamic getIcon(
      Activityname activityname, Uformname uformName, Metadata metadata) {
    double iconSize = (_regimentViewModel.regimentMode == RegimentMode.Schedule)
        ? 40.0.sp
        : 40.0.sp;
    try {
      if (metadata?.icon != null) {
        if (metadata?.icon?.toLowerCase()?.contains('.svg') ?? false) {
          return SvgPicture.network(
            metadata?.icon,
            height: iconSize,
            width: iconSize,
            color: Colors.white,
          );
        } else {
          return CachedNetworkImage(
            imageUrl: metadata?.icon,
            height: iconSize,
            width: iconSize,
            color: Colors.white,
            errorWidget: (context, url, error) {
              return getDefaultIcon(activityname, uformName, iconSize);
            },
          );
        }
      } else {
        return getDefaultIcon(activityname, uformName, iconSize);
      }
    } catch (e) {
      return getDefaultIcon(activityname, uformName, iconSize);
    }
  }

  dynamic getDefaultIcon(
    Activityname activityname,
    Uformname uformName,
    double iconSize,
  ) {
    bool isDefault = true;
    dynamic cardIcon = 'assets/launcher/myfhb1.png';
    switch (activityname) {
      case Activityname.DIET:
        cardIcon = Icons.fastfood_rounded;
        break;
      case Activityname.VITALS:
        if (uformName == Uformname.BLOODPRESSURE) {
          cardIcon = 'assets/devices/bp_dashboard.png';
          isDefault = false;
        } else if (uformName == Uformname.BLOODSUGAR) {
          isDefault = false;
          cardIcon = 'assets/devices/gulcose_dashboard.png';
        } else if (uformName == Uformname.PULSE) {
          isDefault = false;
          cardIcon = 'assets/devices/os_dashboard.png';
        }
        break;
      case Activityname.MEDICATION:
        cardIcon = Icons.medical_services;
        break;
      case Activityname.SCREENING:
        cardIcon = Icons.screen_search_desktop;
        break;
      default:
        cardIcon = 'assets/launcher/myfhb1.png';
    }
    Widget cardIconWidget = (cardIcon is String)
        ? Image.asset(
            cardIcon,
            height: isDefault ? iconSize : iconSize - 5.0.sp,
            width: isDefault ? iconSize : iconSize - 5.0.sp,
          )
        : Icon(
            cardIcon,
            size: iconSize - 5.0.sp,
            color: Colors.white,
          );
    return cardIconWidget;
  }

  @override
  Widget build(BuildContext context) {
    _regimentViewModel = Provider.of<RegimentViewModel>(context);
    _regimentViewModel.handleSearchField(
      controller: searchController,
      focusNode: searchFocus,
    );
    return Column(
      children: [
        Visibility(
          visible: _regimentViewModel.regimentsDataAvailable,
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.all(10.0.sp),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        child: Icon(
                          Icons.chevron_left_rounded,
                          size: 24.0.sp,
                          color: Color(CommonUtil().getMyPrimaryColor()),
                        ),
                        onTap: () {
                          _regimentViewModel.handleSearchField();
                          _regimentViewModel.getRegimentDate(isPrevious: true);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5.0.w,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          DateTime selectedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101),
                            initialDate: _regimentViewModel.selectedDate,
                          );
                          if (selectedDate != null) {
                            _regimentViewModel.handleSearchField();
                            _regimentViewModel.getRegimentDate(
                              dateTime: selectedDate,
                            );
                          }
                        },
                        child: Text(
                          '${_regimentViewModel.regimentDate}',
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: Color(CommonUtil().getMyPrimaryColor()),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.0.w,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 24.0.sp,
                          color: Color(CommonUtil().getMyPrimaryColor()),
                        ),
                        onTap: () {
                          _regimentViewModel.handleSearchField();
                          _regimentViewModel.getRegimentDate(isNext: true);
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 2.0.w,
                  ),
                  child: Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _regimentViewModel.handleSearchField();
                            _regimentViewModel.switchRegimentMode();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.0.sp,
                              vertical: 2.0.sp,
                            ),
                            child: Text(
                              _regimentViewModel.regimentMode ==
                                      RegimentMode.Schedule
                                  ? symptoms
                                  : scheduled,
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                color: Color(CommonUtil().getMyPrimaryColor()),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 5.0.w,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              ProfileResponseModel profileResponseModel =
                                  await Provider.of<RegimentViewModel>(context,
                                          listen: false)
                                      .getProfile();
                              if (profileResponseModel.isSuccess &&
                                  profileResponseModel?.result?.profileData !=
                                      null &&
                                  _regimentViewModel.regimentStatus !=
                                      RegimentStatus.DialogOpened) {
                                _regimentViewModel.updateRegimentStatus(
                                    RegimentStatus.DialogOpened);
                                await showDialog(
                                  context: context,
                                  builder: (context) => EventListWidget(
                                    profileResultModel:
                                        profileResponseModel.result,
                                  ),
                                );
                                _regimentViewModel.updateRegimentStatus(
                                    RegimentStatus.DialogClosed);
                              }
                            },
                            child: Icon(
                              Icons.access_time,
                              size: 30.0.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _regimentViewModel.regimentsDataAvailable,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0.w,
              vertical: 5.0.h,
            ),
            child: Visibility(
              visible: _regimentViewModel.searchExpanded,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _regimentViewModel.changeSearchExpanded(false);
                    },
                    child: Center(
                      child: Icon(
                        Icons.cancel,
                        color: Colors.black,
                        size: 30.0.sp,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0.w,
                  ),
                  Expanded(
                    child: SearchWidget(
                      searchController: searchController,
                      searchFocus: searchFocus,
                      onChanged: _regimentViewModel.onSearch,
                      padding: 0.0,
                    ),
                  ),
                ],
              ),
              replacement: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      _regimentViewModel.regimentMode == RegimentMode.Schedule
                          ? planActivities
                          : planSymptoms,
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        color: Color(CommonUtil().getMyPrimaryColor()),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _regimentViewModel.changeSearchExpanded(true);
                    },
                    child: Center(
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 30.0.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Consumer<RegimentViewModel>(
            builder: (context, regimentViewModel, child) {
              print(regimentViewModel.regimentsData?.message);
              if (regimentViewModel.regimentStatus == RegimentStatus.Loading) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(CommonUtil().getMyPrimaryColor()),
                    ),
                  ),
                );
              } else if ((regimentViewModel.regimentsList?.length ?? 0) > 0) {
                var regimentsList = regimentViewModel.regimentsList;
                if ((regimentsList?.length ?? 0) > 0) {
                  if (regimentViewModel.initialShowIndex != null) {
                    Future.delayed(Duration(microseconds: 1), () {
                      scrollController.scrollToIndex(
                        regimentViewModel.initialShowIndex,
                        preferPosition: AutoScrollPosition.middle,
                      );
                      regimentViewModel.updateInitialShowIndex(
                        isDone: true,
                      );
                    });
                  }
                  return ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      bottom: 10.0.h,
                    ),
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: regimentsList?.length ?? 0,
                    itemBuilder: (context, index) {
                      var regimentData = (index < regimentsList.length)
                          ? regimentsList[index]
                          : RegimentDataModel();
                      return AutoScrollTag(
                        key: ValueKey(index),
                        index: index,
                        controller: scrollController,
                        child: RegimentDataCard(
                          index: index,
                          title: regimentData.title,
                          time: DateFormat('hh:mm\na')
                              .format(regimentData.estart),
                          color: getColor(regimentData.activityname,
                              regimentData.uformname, regimentData.metadata),
                          icon: getIcon(regimentData.activityname,
                              regimentData.uformname, regimentData.metadata),
                          vitalsData: regimentData.uformdata?.vitalsData,
                          eid: regimentData.eid,
                          mediaData: regimentData.otherinfo,
                          startTime: regimentData.estart,
                          regimentData: regimentData,
                        ),
                      );
                    },
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(
                          10.0.sp,
                        ),
                        child: Text(
                          (regimentViewModel.regimentMode ==
                                  RegimentMode.Schedule
                              ? noRegimentScheduleData
                              : noRegimentSymptomsData),
                          style: TextStyle(
                            fontSize: 16.0.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(
                        10.0.sp,
                      ),
                      child: Text(
                        regimentViewModel.regimentsData?.message ??
                            (regimentViewModel.regimentMode ==
                                    RegimentMode.Schedule
                                ? noRegimentScheduleData
                                : noRegimentSymptomsData),
                        style: TextStyle(
                          fontSize: 16.0.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
