import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/data/models/dev_settings.dart';
import 'package:simple_todo_flutter/data/models/user_info/user_info.dart';
import 'package:simple_todo_flutter/resources/constants.dart';
import 'package:simple_todo_flutter/resources/dimens.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/resources/icons/icons.dart';
import 'package:simple_todo_flutter/resources/routes.dart';
import 'package:simple_todo_flutter/ui/custom/button_icon_rounded.dart';
import 'package:simple_todo_flutter/ui/custom/input_field_rounded.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_todo_flutter/ui/user/user_edit_view_model.dart';

class UserEditPage extends StatefulWidget {
  final UserInfo userInfo;
  final DevSettings devSettings;

  const UserEditPage(
      {Key? key, required this.userInfo, required this.devSettings})
      : super(key: key);

  @override
  _UserEditPageState createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final UserEditViewModel _model = UserEditViewModel();

  final TextEditingController _cntrlTitle = TextEditingController();
  final _formKeyTitle = GlobalKey<FormState>();

  @override
  void initState() {
    _model.userInfo = widget.userInfo;
    _model.devSettings = widget.devSettings;

    _setListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
            color: context.surface,
            borderRadius: new BorderRadius.only(
                topLeft: Radiuss.middle, topRight: Radiuss.middle)),
        child: Container(
          margin: EdgeInsets.only(
            top: Margin.middle_smaller.h,
          ),
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: Margin.middle),
                child: Row(
                  children: [
                    _buttonRoundedWithIcon(
                        backgroundColor: context.surfaceAccent,
                        iconColor: context.background,
                        icon: IconsC.back,
                        onTap: () => Routes.back(context)),
                    Expanded(
                      child: Container(),
                    ),
                    _buttonRoundedWithIcon(
                      backgroundColor: context.primary,
                      iconColor: context.surface,
                      icon: IconsC.check,
                      onTap: () async {
                        if(!_formKeyTitle.currentState!.validate())
                          return;

                        await _model.updateInfo();
                        Routes.back(context, result: _model.userInfo);
                      } ,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Margin.small.h,
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _photoWidget(),
                    SizedBox(
                      height: Margin.middle.h,
                    ),
                    _titleOfCategory(
                        text: "profile.name".tr()
                    ),
                    SizedBox(
                      height: Margin.small.h,
                    ),
                    _inputField(
                      label: "profile.name".tr(),
                      maxLines: 1,
                      textController: _cntrlTitle,
                      formKey: _formKeyTitle,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "error.title_cant_be_empty".tr();
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: Margin.middle.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _photoWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buttonRoundedWithIcon(
          backgroundColor: context.surfaceAccent,
          icon: IconsC.delete,
          iconColor: context.background,
          onTap: () => setState(() => _model.userInfo.photoURL = null) ,
        ),
        SizedBox(
          width: Margin.middle.w,
        ),

        Container(
          height: Dimens.avatar_photo_size_middle,
          width: Dimens.avatar_photo_size_middle,
          child: ClipOval(
            child: FittedBox(
              fit: BoxFit.cover,
              alignment: Alignment.centerLeft,
              child: Image.network(_model.userInfo.photoURL ??
                  _model.devSettings.emptyPhotoURL),
            ),
          ),
        ),
        SizedBox(
          width: Margin.middle.w,
        ),
        _buttonRoundedWithIcon(
            backgroundColor: context.surfaceAccent,
            icon: IconsC.upload,
            iconColor: context.background,
            onTap: () {
              _model.pickAndUploadPhoto().then((value) => setState((){}));
            }
        ),
      ],
    );
  }

  Widget _buttonRoundedWithIcon(
      {required Color backgroundColor,
        required Color iconColor,
        required IconData icon,
        required VoidCallback onTap, String? text}) {

    return ButtonIconRounded(
      icon: icon,
      onTap: onTap,
      backgroundColor: backgroundColor,
      iconColor: iconColor,
      text: text ?? null,
      textColor: context.textDefault,
      padding: EdgeInsets.symmetric(
          vertical: Paddings.small, horizontal: Paddings.middle),
    );
  }

  Widget _inputField(
      {Key? formKey, required String label,
        required int maxLines,
        required TextEditingController textController,
        VoidCallback? onTap,
        IconData? buttonIcon,
        bool? shouldUnfocus,
        FormFieldValidator<String>? validator}) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Margin.middle,
      ),
      child: InputFieldRounded(
        formKey: formKey ?? null,
        labelText: label,
        maxLines: maxLines,
        textController: textController,
        borderColor: context.primary,
        textColor: context.textDefault,
        labelUnselectedColor: context.textSubtitleDefault,
        buttonIcon: buttonIcon ?? null,
        onTap: onTap,
        shouldUnfocus: shouldUnfocus ?? null,
        validator: validator ?? null,
      ),
    );
  }

  Widget _titleOfCategory({required String text}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          left: Margin.middle
      ),
      child: Text(text,
        style: TextStyle(
          color: context.textDefault,
          fontWeight: FontWeight.bold,
          fontSize: Dimens.text_normal,
        ),),
    );
  }

  _setListeners() {
    _cntrlTitle..addListener(() {
      _model.userInfo.name = _cntrlTitle.text;
    })..text = _model.userInfo.name ?? Constants.EMPTY_STRING;
  }
}
