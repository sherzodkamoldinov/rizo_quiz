/// Сводит произвольный язык-код хоста к одному из трёх поддерживаемых
/// пакетом: `ru`, `uz` (латиница), `en`.
///
/// Алиасы:
/// - `kr`, `uz_Cyrl`, `uz-Cyrl` → `uz` (узбекская кириллица показывает
///   латинский узбекский, т.к. отдельной локали нет).
/// - `zh`, `zh_CN`, `zh-CN`     → `en` (китайский фоллбэчится на английский).
/// - Всё прочее → `ru`.
String normalizeQuizLang(String lang) {
  switch (lang) {
    case 'ru':
    case 'uz':
    case 'en':
      return lang;
    case 'kr':
    case 'uz_Cyrl':
    case 'uz-Cyrl':
      return 'uz';
    case 'zh':
    case 'zh_CN':
    case 'zh-CN':
      return 'en';
    default:
      return 'ru';
  }
}
