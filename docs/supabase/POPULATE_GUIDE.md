# Supabase: пошаговое наполнение базы

Цель — за **3 запуска SQL** получить полностью рабочий квиз со 134 вопросами на ru/uz/en в 5 категориях.

> Используется тот же Supabase проект, что и в `rizo_go` и `rizo_driver_mobile`. URL и anon key уже зашиты в `Constants` обоих приложений.

---

## Шаг 1. Создать схему

Открой Supabase Studio → **SQL Editor** → `+ New query`.

Скопируй содержимое `0001_init.sql` (рядом с этим документом) → **Run**.

Должны появиться 3 таблицы (`quiz_categories`, `quiz_questions`, `quiz_player_scores`) и 6 RLS-политик.

Проверь:
```sql
select table_name
from information_schema.tables
where table_schema = 'public' and table_name like 'quiz_%';
```
Ожидаем 3 строки.

---

## Шаг 2. Залить 5 категорий

Скопируй `seeds/01_categories.sql` → **Run**.

INSERT защищён `ON CONFLICT (key) DO NOTHING`, так что повторный запуск безопасен.

Проверь:
```sql
select key, name_ru, sort_order from public.quiz_categories order by sort_order;
```
Ожидаем 5 строк (science, geography, history, cinema, music).

---

## Шаг 3. Залить вопросы (5 файлов по очереди)

Каждый файл — отдельный INSERT-блок для одной категории. Запускай по одному:

| Файл | Категория | Вопросов |
|------|-----------|----------|
| `seeds/02_science.sql`   | Наука      | 28 |
| `seeds/03_geography.sql` | География  | 28 |
| `seeds/04_history.sql`   | История    | 26 |
| `seeds/05_cinema.sql`    | Кино       | 26 |
| `seeds/06_music.sql`     | Музыка     | 26 |
| **Итого**                |            | **134** |

После всех 5:
```sql
select c.key, count(q.id) as questions
from public.quiz_categories c
left join public.quiz_questions q on q.category_id = c.id and q.is_active = true
group by c.key
order by c.key;
```
Ожидаем `cinema=26, geography=28, history=26, music=26, science=28`.

---

## Качество переводов

- **ru** — оригинал из `design_handoff_rizo_quiz/questions.js`, 100% надёжный.
- **en** — собран мной, для общеизвестных тем (наука, история, география, поп-культура).
- **uz** — собран мной на современной латинице, **может содержать стилистические неточности**. Перед публикацией прогони хотя бы выборочно через нативного носителя или редактора.

Если найдёшь ошибку в конкретном вопросе:
```sql
update public.quiz_questions
set question_uz = 'правильная_формулировка',
    options_uz = '["v1","v2","v3","v4"]'::jsonb
where id = 'тот-самый-uuid';
```

---

## Как работают очки и лидерборд

- Раунд = 10 вопросов в одной категории. Очки за вопрос: `100 + secondsLeft × 10` (см. `lib/src/utils/quiz_scoring.dart`).
- После раунда клиент делает **UPSERT** в `quiz_player_scores`:
  ```sql
  INSERT … (user_id, category_id, period_key, score, …)
  ON CONFLICT (user_id, category_id, period_key) DO UPDATE
    SET score = EXCLUDED.score, …
    WHERE EXCLUDED.score > quiz_player_scores.score;
  ```
  → запись обновляется **только если новый score выше**, чем сохранённый best за эту неделю.
- `period_key` — `YYYY-MM-DD` понедельника недели (UTC). Клиент считает локально, см. `QuizPeriodKey.currentWeek()`.
- **Лидерборд** = `SUM(score) GROUP BY user_id` за текущую неделю. Сбрасывается естественным образом каждую неделю.
- **Bottom sheet** на тап по строке лидерборда = разбивка `SELECT category_id, score WHERE user_id = ? AND period_key = ?`.

---

## Сервисное

Сброс лидерборда вручную (для тестов):
```sql
delete from public.quiz_player_scores where user_id = '<test-user-id>';
```

Отключить «плохой» вопрос без удаления:
```sql
update public.quiz_questions set is_active = false where id = '...';
```

Чистка истории за прошлые недели (необязательно):
```sql
delete from public.quiz_player_scores
where period_key < to_char(date_trunc('week', now() at time zone 'utc') - interval '8 weeks', 'YYYY-MM-DD');
```
