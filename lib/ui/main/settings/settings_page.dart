import 'package:flutter/material.dart';
import 'package:simple_todo_flutter/resources/colors.dart';
import 'package:simple_todo_flutter/ui/main/settings/settings_view_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SettingsViewModel _model = SettingsViewModel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Settings"),
          MaterialButton(
              color: context.primary,
              onPressed: () {
                _model.logoutFromAccount(context);
              },
            ),
        ],
      ),
    );
  }
}
