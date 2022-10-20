import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:snde/functions.dart';

import 'package:snde/services/store_service.dart';

class ChangeLanguagePage extends StatefulWidget {
  const ChangeLanguagePage({Key? key}) : super(key: key);

  @override
  _ChangeLanguagePageState createState() => _ChangeLanguagePageState();
}

class _ChangeLanguagePageState extends State<ChangeLanguagePage> {
  _changeLang(
      {required String language, required StoreService langModel}) async {
    await FlutterI18n.refresh(context, Locale(language));
    langModel.changeLanguage(language);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> languages = [
      {'text': 'العربية', 'value': 'ar', 'img': 'ar.png'},
      {'text': 'English', 'value': 'en', 'img': 'en.png'},
      {'text': 'français', 'value': 'fr', 'img': 'fr.png'},
    ];
    final StoreService modal = StoreService.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t(context, 'change_language')),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          bottom: 15.0,
        ),
        children: <Widget>[
          for (var lang in languages)
            _buildItem(
              lang['img'],
              lang['text'],
              isSelected: modal.language == lang['value'],
              onTap: () => _changeLang(
                  langModel: modal, language: lang['value'] ?? 'ar'),
            ),
        ],
      ),
    );
  }

  // Items
  Widget _buildItem(icon, String? text,
      {required void Function()? onTap, bool isSelected = false}) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: onTap,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              'assets/images/$icon',
              width: 25,
              height: 25,
            ),
          ),
          title: Text(
            '$text',
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: isSelected
              ? const Icon(
                  Icons.check,
                  size: 26.0,
                )
              : null,
        ),
        const Divider(
          color: Color(0XFFe4e4e4),
          height: 2,
        ),
      ],
    );
  }
}
