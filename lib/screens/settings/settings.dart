import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:adguard_home_manager/screens/settings/theme_modal.dart';
import 'package:adguard_home_manager/screens/settings/custom_list_tile.dart';
import 'package:adguard_home_manager/screens/settings/section_label.dart';
import 'package:adguard_home_manager/screens/servers/servers.dart';
import 'package:adguard_home_manager/screens/settings/advanced_setings.dart';
import 'package:adguard_home_manager/screens/settings/general_settings.dart';

import 'package:adguard_home_manager/providers/servers_provider.dart';
import 'package:adguard_home_manager/providers/app_config_provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);
    final serversProvider = Provider.of<ServersProvider>(context);

    final statusBarHeight = MediaQuery.of(context).viewInsets.top;

    String getThemeString() {
      switch (appConfigProvider.selectedThemeNumber) {
        case 0:
          return AppLocalizations.of(context)!.systemDefined;

        case 1:
          return AppLocalizations.of(context)!.light;

        case 2:
          return AppLocalizations.of(context)!.dark;

        default:
          return "";
      }
    }

    void openThemeModal() {
      showModalBottomSheet(
        context: context, 
        isScrollControlled: true,
        builder: (context) => ThemeModal(
          statusBarHeight: statusBarHeight,
          selectedTheme: appConfigProvider.selectedThemeNumber,
        ),
        backgroundColor: Colors.transparent,
      );
    }

    void navigateServers() {
      Future.delayed(const Duration(milliseconds: 0), (() {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const Servers())
        );
      }));
    }

    return ListView(
      children: [
        SectionLabel(label: AppLocalizations.of(context)!.appSettings),
        CustomListTile(
          leadingIcon: Icons.light_mode_rounded,
          label: AppLocalizations.of(context)!.theme, 
          description: getThemeString(),
          onTap: openThemeModal,
        ),
        CustomListTile(
          leadingIcon: Icons.storage_rounded,
          label: AppLocalizations.of(context)!.servers,
          description: serversProvider.selectedServer != null
            ? serversProvider.serverStatus.data != null
              ? "${AppLocalizations.of(context)!.connectedTo} ${serversProvider.selectedServer!.name}"
              : "${AppLocalizations.of(context)!.selectedServer} ${serversProvider.selectedServer!.name}"
            : AppLocalizations.of(context)!.noServerSelected,
          onTap: navigateServers,
        ),
        CustomListTile(
          leadingIcon: Icons.settings,
          label: AppLocalizations.of(context)!.generalSettings,
          description: AppLocalizations.of(context)!.generalSettingsDescription,
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const GeneralSettings()
              )
            )
          },
        ),
        CustomListTile(
          leadingIcon: Icons.build_outlined,
          label: AppLocalizations.of(context)!.advancedSettings,
          description: AppLocalizations.of(context)!.advancedSetupDescription,
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AdvancedSettings()
              )
            )
          },
        ),
        SectionLabel(label: AppLocalizations.of(context)!.aboutApp),
        CustomListTile(
          label: AppLocalizations.of(context)!.appVersion, 
          description: appConfigProvider.getAppInfo!.version,
        ),
        CustomListTile(
          label: AppLocalizations.of(context)!.createdBy, 
          description: "JGeek00",
        ),
      ],
    );
  }
}