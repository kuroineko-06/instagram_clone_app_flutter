class Language {
  final int id;
  final String name;
  final String languageCode;

  Language({required this.id, required this.name, required this.languageCode});

  static List<Language> languageList() {
    return <Language>[
      Language(id: 1, name: "English", languageCode: "en"),
      Language(id: 2, name: "Việt Nam", languageCode: "vi"),
      Language(id: 3, name: "Français", languageCode: "fr"),
    ];
  }
}
