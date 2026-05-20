# rizo_quiz

Shared квиз-фича для Rizo GO, Rizo Driver и любых будущих приложений. Полностью самодостаточный пакет: своя тема, шрифты, звуки, BLoC и UI. Хост передаёт только Supabase-клиент и идентификацию игрока.

## Установка

В корне твоего Flutter-приложения:

```yaml
dependencies:
  rizo_quiz:
    path: ../rizo_quiz
```

Затем `flutter pub get`.

Зависимости пакета: `flutter_bloc`, `equatable`, `supabase_flutter`, `audioplayers`. Шрифты Source Serif 4, Geist, JetBrains Mono идут внутри пакета.

## Использование

Хост уже должен где-то вызвать `Supabase.initialize(...)`. После этого открыть квиз — одной строкой:

```dart
import 'package:rizo_quiz/rizo_quiz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Navigator.of(context).push(MaterialPageRoute(
  builder: (_) => QuizEntry(
    supabaseClient: Supabase.instance.client,
    player: QuizPlayer(
      userId: 'user-123',
      displayName: 'Sherzod',
      lang: 'ru', // 'ru' | 'uz' | 'en'
    ),
    // Опционально: баннер сверху экрана вопроса.
    // rizo_go: статус поиска водителя. driver: «Новый заказ».
    contextBannerBuilder: (ctx) => MyHostBanner(),
  ),
));
```

Всё остальное — категории, вопросы, лидерборд, тосты, шейк, тики, тема — пакет рисует и обрабатывает сам.

## Supabase

Перед запуском убедись, что в твоём Supabase-проекте созданы таблицы и политики. Открой пошаговое руководство:

- [`docs/supabase/0001_init.sql`](docs/supabase/0001_init.sql) — миграция (запускается один раз).
- [`docs/supabase/POPULATE_GUIDE.md`](docs/supabase/POPULATE_GUIDE.md) — пошаговое наполнение категориями и вопросами.

## Кастомизация

Через `RizoQuizConfig`:

```dart
QuizEntry(
  // ...
  config: const RizoQuizConfig(
    soundEnabled: true,                   // выключить звуки
    colors: QuizColors(/* свои токены */), // перекрасить палитру
    tablePrefix: 'quiz_',                 // префикс таблиц Supabase
  ),
);
```

## Что НЕ делает пакет

- Не инициализирует Supabase. Это делает хост.
- Не делает аутентификацию. Хост передаёт `userId`/`displayName` сам.
- Не сохраняет gems/streak. По решению на MVP — нет sink-механики.
- Не подключает Firebase / push / аналитику. Только квиз.

## Структура

```
lib/
├── rizo_quiz.dart                 # public exports
└── src/
    ├── entry/                     # QuizEntry + конфиг
    ├── theme/                     # цвета, типографика, тема
    ├── domain/                    # entities + abstract repository
    ├── data/                      # Supabase data-source + impl repository
    ├── bloc/                      # QuizBloc + events + state
    ├── services/                  # QuizAudioService
    ├── localization/              # ru/uz/en строки UI
    ├── utils/                     # scoring, верстки
    └── presentation/
        ├── pages/                 # 4 экрана: categories/question/result/leaderboard
        └── widgets/
            ├── atoms/             # eyebrow, avatar, pill, glyph и т.п.
            ├── molecules/         # top_bar, timer_pill, option_choice, podium_column...
            ├── organisms/         # categories_grid, podium, leaderboard_list...
            └── effects/           # shake, rise, pulse
```

## Лицензии встроенных шрифтов

- **Source Serif 4** — SIL OFL 1.1 (Adobe).
- **Geist** — SIL OFL 1.1 (Vercel).
- **JetBrains Mono** — SIL OFL 1.1 (JetBrains).

Все три свободны для коммерческого использования.
