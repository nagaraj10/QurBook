import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/model/Category/CategoryResponseList.dart';
import 'package:myfhb/src/model/Media/DeviceModel.dart';

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
            flex: 1,
            child: Container(
              height: 50,
            ),
          ),
          getCustomGridView(context),
          Expanded(
            flex: 1,
            child: FloatingActionButton(
              backgroundColor: Colors.white54,
              child: Icon(
                Icons.close,
                color: Color(new CommonUtil().getMyPrimaryColor()),
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
    return new Expanded(
        flex: 5,
        child: new Center(
            child: new Container(
                child: GridView.count(
          padding: const EdgeInsets.all(20.0),
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          crossAxisCount: 2,
          children: getWidgetsFordevices(context),
        ))));
  }

  List<Widget> getWidgetsFordevices(BuildContext context) {
    List<Widget> categoryWidgetList = new List();

    List<CategoryData> catgoryDataList = PreferenceUtil.getCategoryType();

    for (int i = 0; i < catgoryDataList.length; i++) {
      categoryWidgetList.add(InkWell(
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: SizedBox(
                width: 25,
                height: 25,
                child: CachedNetworkImage(
                  imageUrl: Constants.BASERURL + catgoryDataList[i].logo,
                  color: Colors.white70,
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
              onTap: () {
                callBackPage(catgoryDataList[i].categoryName, context,catgoryDataList[i].id);
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
          callBackPage(catgoryDataList[i].categoryName, context,catgoryDataList[i].id);
        },
      ),);
    }
    print('categoryWidgetList' + categoryWidgetList.length.toString());

    return categoryWidgetList;
  }

  callBackPage(String categoryName, BuildContext context,String categoryID) {
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
