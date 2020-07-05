import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myfhb/common/CommonUtil.dart';
import 'package:myfhb/common/PreferenceUtil.dart';
import 'package:myfhb/constants/fhb_constants.dart' as Constants;
import 'package:myfhb/src/model/Media/DeviceModel.dart';

class OverlayDeviceDialog extends ModalRoute<void> {
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
    List<Widget> deviceWidgetList = new List();
    List<DeviceModel> mediaDataForDevice =
        new CommonUtil().getAllDevices(PreferenceUtil.getMediaType());

    for (int i = 0; i < mediaDataForDevice.length; i++) {
      deviceWidgetList.add(GestureDetector(
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: SizedBox(
                width: 25,
                height: 25,
                child: CachedNetworkImage(
                  imageUrl: Constants.BASE_URL + mediaDataForDevice[i].imageUrl,
                  color: Colors.white70,
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
              onTap: () {
                callBackPage(mediaDataForDevice[i].deviceName, context);
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    mediaDataForDevice[i].deviceName,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )),
          ],
        ),
        onTap: () {
          callBackPage(mediaDataForDevice[i].deviceName, context);
        },
      ));
    }
    

    return deviceWidgetList;
  }

  callBackPage(String deviceName, BuildContext context) {
    PreferenceUtil.saveString(Constants.KEY_DEVICENAME, deviceName)
        .then((onValue) {
      Navigator.pop(context);
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
