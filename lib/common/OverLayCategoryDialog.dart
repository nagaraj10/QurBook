import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'CommonUtil.dart';
import 'PreferenceUtil.dart';
import '../constants/fhb_constants.dart' as Constants;
import '../src/model/Category/CategoryData.dart';
import '../src/model/Category/CategoryResponseList.dart';
import '../src/model/Category/catergory_result.dart';
import '../src/model/Media/DeviceModel.dart';
import '../src/utils/screenutils/size_extensions.dart';

class OverlayCategoryDialog extends ModalRoute<void> {
  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 50.0.h,
            ),
          ),
          getCustomGridView(context),
          Expanded(
            child: FloatingActionButton(
              backgroundColor: Colors.white54,
              child: Icon(
                Icons.close,
                color: Color(CommonUtil().getMyPrimaryColor()),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }

  Widget getCustomeGridViewClone() {
    return Expanded(
        flex: 5,
        child: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(5),
              sliver: SliverGrid.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 5,
                  crossAxisCount: 2,
                  children: getWidgetsFordevices(null)),
            ),
          ],
        ));
  }

  Widget getCustomGridView(BuildContext context) {
    return Expanded(
        flex: 5,
        child: Center(
            child: Container(
                child: GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: getWidgetsFordevices(context),
        ))));
  }

  List<Widget> getWidgetsFordevices(BuildContext context) {
    var categoryWidgetList = List<Widget>();

    final catgoryDataList = PreferenceUtil.getCategoryTypeDisplay(
        Constants.KEY_CATEGORYLIST_VISIBLE);

    for (var i = 0; i < catgoryDataList.length; i++) {
      categoryWidgetList.add(
        InkWell(
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: SizedBox(
                  width: 25.0.h,
                  height: 25.0.h,
                  child: CachedNetworkImage(
                    imageUrl: Constants.BASE_URL + catgoryDataList[i].logo,
                    color: Colors.white70,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                onTap: () {
                  callBackPage(catgoryDataList[i].categoryName, context,
                      catgoryDataList[i].id);
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
              ),
              Container(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Text(
                      catgoryDataList[i].categoryName,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )),
            ],
          ),
          onTap: () {
            callBackPage(catgoryDataList[i].categoryName, context,
                catgoryDataList[i].id);
          },
        ),
      );
    }

    return categoryWidgetList;
  }

  callBackPage(String categoryName, BuildContext context, String categoryID) {
    PreferenceUtil.saveString(Constants.KEY_CATEGORYNAME, categoryName)
        .then((onValue) {
      PreferenceUtil.saveString(Constants.KEY_CATEGORYID, categoryID)
          .then((value) {
        Navigator.pop(context);
      });
    });
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
