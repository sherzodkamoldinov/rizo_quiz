-- 5 базовых категорий. Запускается ОДИН раз после миграции 0001_init.sql.
-- ON CONFLICT защищает от случайного повторного запуска.

insert into public.quiz_categories
    (key, name_ru, name_uz, name_en, subtitle_ru, subtitle_uz, subtitle_en, glyph, sort_order)
values
    ('science',   'Наука',     'Fan',        'Science',   'Физика, химия, биология', 'Fizika, kimyo, biologiya',     'Physics, chemistry, biology', '◎', 0),
    ('geography', 'География', 'Geografiya', 'Geography', 'Страны, столицы, природа','Davlatlar, poytaxtlar, tabiat','Countries, capitals, nature', '◳', 1),
    ('history',   'История',   'Tarix',      'History',   'События и даты',          'Voqealar va sanalar',          'Events and dates',            '▲', 2),
    ('cinema',    'Кино',      'Kino',       'Cinema',    'Фильмы и режиссёры',      'Filmlar va rejissyorlar',      'Movies and directors',         '◐', 3),
    ('music',     'Музыка',    'Musiqa',     'Music',     'Хиты и исполнители',      'Hitlar va ijrochilar',          'Hits and artists',             '♪', 4)
on conflict (key) do nothing;
