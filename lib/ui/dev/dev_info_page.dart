import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/ui/custom/animated_gesture_detector.dart';
import 'package:simple_todo_flutter/ui/dev/dev_info_page_view_model.dart';

class DevInfoPage extends StatefulWidget {
  const DevInfoPage({Key? key}) : super(key: key);

  @override
  _DevInfoPageState createState() => _DevInfoPageState();
}

class _DevInfoPageState extends State<DevInfoPage> {
  DevInfoPageViewModel _model = DevInfoPageViewModel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _model.getDevInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: new BoxDecoration(
                  color: context.surface,
                  borderRadius: new BorderRadius.only(
                      topLeft: Radiuss.middle, topRight: Radiuss.middle)),
              child: Container(
                  margin: EdgeInsets.only(
                    top: Margin.middle_smaller.h,
                  ),
                  child: _profileInfoWidget()),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _profileInfoWidget() {
    return Container(
      margin: EdgeInsets.only(left: Margin.middle.w, right: Margin.middle.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: Dimens.avatar_photo_size,
                width: Dimens.avatar_photo_size,
                child: ClipOval(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                    child: _model.devInfo.photoPath.isNotEmpty
                        ? Image.network(
                            _model.devInfo.photoPath,
                          )
                        : Container(
                            color: context.error,
                          ),
                  ),
                ),
              ),
              SizedBox(
                width: Margin.middle.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      _model.devInfo.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: context.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: Dimens.text_big_smaller),
                    ),
                    Text(
                      _model.devInfo.email,
                      style: TextStyle(
                          color: context.onSurface,
                          fontWeight: FontWeight.w500,
                          fontSize: Dimens.text_small_bigger),
                    ),
                    _socialMediaLayout()
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: Margin.middle.h,
          ),
        ],
      ),
    );
  }

  Widget _socialMediaLayout() {
    return Container(
      margin: EdgeInsets.only(
        top: Margin.small.h
      ),
      child: Row(
        children: [
          AnimatedGestureDetector(
            child: Image.asset(ImagePath.INSTAGRAM, height: Dimens.icon_size, width: Dimens.icon_size,),
            onTap: () =>
                _model.openLink(_model.devInfo.socialNetworks["inst"]!),
          ),
          SizedBox(
            width: Margin.small.w,
          ),
          AnimatedGestureDetector(
            child: Image.asset(ImagePath.TWITTER, height: Dimens.icon_size, width: Dimens.icon_size,),
            onTap: () =>
                _model.openLink(_model.devInfo.socialNetworks["twitter"]!),
          ),
          SizedBox(
            width: Margin.small.w,
          ),
          AnimatedGestureDetector(
            child: Image.asset(ImagePath.GITHUB, height: Dimens.icon_size, width: Dimens.icon_size,),
            onTap: () =>
                _model.openLink(_model.devInfo.socialNetworks["github"]!),
          ),
        ],
      ),
    );
  }
}
