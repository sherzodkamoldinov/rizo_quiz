-- ─────────────────────────────────────────────────────────────────────────────
-- MUSIC — 26 вопросов (11 из дизайна + 15 новых)
-- ─────────────────────────────────────────────────────────────────────────────

with cat as (
    select id from public.quiz_categories where key = 'music'
)
insert into public.quiz_questions
    (category_id, type, question_ru, question_uz, question_en, options_ru, options_uz, options_en, correct_index)
values
    -- ─── Из дизайна (11) ────────────────────────────────────────────────────
    ((select id from cat), 'multiple_choice',
        'Сколько струн у классической гитары?',
        'Klassik gitarada nechta tor bor?',
        'How many strings does a classical guitar have?',
        '["4","5","6","7"]'::jsonb, '["4","5","6","7"]'::jsonb, '["4","5","6","7"]'::jsonb, 2),

    ((select id from cat), 'true_false',
        'Моцарт писал музыку в XVIII веке.',
        'Mosart musiqalarini XVIII asrda yozgan.',
        'Mozart wrote music in the 18th century.',
        '["Правда","Ложь"]'::jsonb, '["Rost","Yolg‘on"]'::jsonb, '["True","False"]'::jsonb, 0),

    ((select id from cat), 'multiple_choice',
        'Какой инструмент имеет 88 клавиш?',
        'Qaysi cholg‘u asbobida 88 ta klavish bor?',
        'Which instrument has 88 keys?',
        '["Орган","Аккордеон","Пианино","Синтезатор"]'::jsonb,
        '["Organ","Akkordeon","Pianino","Sintezator"]'::jsonb,
        '["Organ","Accordion","Piano","Synthesizer"]'::jsonb, 2),

    ((select id from cat), 'multiple_choice',
        'Из какой страны группа The Beatles?',
        'The Beatles guruhi qaysi davlatdan?',
        'The Beatles are from which country?',
        '["США","Великобритания","Ирландия","Канада"]'::jsonb,
        '["AQSh","Buyuk Britaniya","Irlandiya","Kanada"]'::jsonb,
        '["USA","United Kingdom","Ireland","Canada"]'::jsonb, 1),

    ((select id from cat), 'true_false',
        'Скрипка относится к струнным инструментам.',
        'Skripka — torli cholg‘u asbob.',
        'The violin is a string instrument.',
        '["Правда","Ложь"]'::jsonb, '["Rost","Yolg‘on"]'::jsonb, '["True","False"]'::jsonb, 0),

    ((select id from cat), 'multiple_choice',
        'Кто написал «Лунную сонату»?',
        '"Oy sonatasi"ni kim yozgan?',
        'Who composed the "Moonlight Sonata"?',
        '["Бах","Бетховен","Шопен","Моцарт"]'::jsonb,
        '["Bax","Betxoven","Shopen","Mosart"]'::jsonb,
        '["Bach","Beethoven","Chopin","Mozart"]'::jsonb, 1),

    ((select id from cat), 'multiple_choice',
        'Какой жанр был у Элвиса Пресли?',
        'Elvis Presli qaysi janrda kuylagan?',
        'What genre was Elvis Presley known for?',
        '["Джаз","Рок-н-ролл","Кантри","Блюз"]'::jsonb,
        '["Jaz","Rok-n-roll","Kantri","Blyuz"]'::jsonb,
        '["Jazz","Rock and roll","Country","Blues"]'::jsonb, 1),

    ((select id from cat), 'true_false',
        'Бетховен оглох в конце жизни.',
        'Betxoven umrining oxirida kar bo‘lib qolgan.',
        'Beethoven became deaf later in life.',
        '["Правда","Ложь"]'::jsonb, '["Rost","Yolg‘on"]'::jsonb, '["True","False"]'::jsonb, 0),

    ((select id from cat), 'multiple_choice',
        'Сколько нот в октаве?',
        'Bir oktavada nechta nota bor?',
        'How many notes are in an octave?',
        '["5","6","7","8"]'::jsonb, '["5","6","7","8"]'::jsonb, '["5","6","7","8"]'::jsonb, 2),

    ((select id from cat), 'multiple_choice',
        'Какая группа исполняет «Bohemian Rhapsody»?',
        '"Bohemian Rhapsody"ni qaysi guruh ijro etadi?',
        'Which band performs "Bohemian Rhapsody"?',
        '["Queen","The Who","Pink Floyd","Led Zeppelin"]'::jsonb,
        '["Queen","The Who","Pink Floyd","Led Zeppelin"]'::jsonb,
        '["Queen","The Who","Pink Floyd","Led Zeppelin"]'::jsonb, 0),

    ((select id from cat), 'true_false',
        'Электрогитара появилась раньше акустической.',
        'Elektrogitara akustik gitaradan oldin paydo bo‘lgan.',
        'The electric guitar predates the acoustic one.',
        '["Правда","Ложь"]'::jsonb, '["Rost","Yolg‘on"]'::jsonb, '["True","False"]'::jsonb, 1),

    -- ─── Новые 15 ───────────────────────────────────────────────────────────
    ((select id from cat), 'multiple_choice',
        'Сколько клавиш на октаве пианино?',
        'Pianinoning bir oktavasida nechta klavish bor?',
        'How many keys are in one piano octave?',
        '["7","8","10","12"]'::jsonb, '["7","8","10","12"]'::jsonb, '["7","8","10","12"]'::jsonb, 3),

    ((select id from cat), 'multiple_choice',
        'Что такое «forte» в музыке?',
        'Musiqada "forte" nimani anglatadi?',
        'What does "forte" mean in music?',
        '["Тихо","Громко","Медленно","Быстро"]'::jsonb,
        '["Past","Baland","Sekin","Tez"]'::jsonb,
        '["Soft","Loud","Slow","Fast"]'::jsonb, 1),

    ((select id from cat), 'true_false',
        'Майкл Джексон выпустил альбом «Thriller» в 1982.',
        'Maykl Jekson "Thriller" albomini 1982-yilda chiqargan.',
        'Michael Jackson released "Thriller" in 1982.',
        '["Правда","Ложь"]'::jsonb, '["Rost","Yolg‘on"]'::jsonb, '["True","False"]'::jsonb, 0),

    ((select id from cat), 'multiple_choice',
        'Кто написал оперу «Дон Жуан»?',
        '"Don Juan" operasini kim yozgan?',
        'Who composed the opera "Don Giovanni"?',
        '["Верди","Моцарт","Вагнер","Россини"]'::jsonb,
        '["Verdi","Mosart","Vagner","Rossini"]'::jsonb,
        '["Verdi","Mozart","Wagner","Rossini"]'::jsonb, 1),

    ((select id from cat), 'multiple_choice',
        'Какой инструмент относится к духовым?',
        'Qaysi cholg‘u puflama asboblar guruhiga kiradi?',
        'Which is a wind instrument?',
        '["Скрипка","Флейта","Барабан","Арфа"]'::jsonb,
        '["Skripka","Fleyta","Baraban","Arfa"]'::jsonb,
        '["Violin","Flute","Drum","Harp"]'::jsonb, 1),

    ((select id from cat), 'true_false',
        'Барабан — ударный инструмент.',
        'Baraban — zarbli cholg‘u asbob.',
        'A drum is a percussion instrument.',
        '["Правда","Ложь"]'::jsonb, '["Rost","Yolg‘on"]'::jsonb, '["True","False"]'::jsonb, 0),

    ((select id from cat), 'multiple_choice',
        'Какой жанр представляет Боб Дилан?',
        'Bob Dilan qaysi janrda ishlaydi?',
        'Which genre is Bob Dylan known for?',
        '["Поп","Хип-хоп","Фолк","Метал"]'::jsonb,
        '["Pop","Xip-xop","Folk","Metal"]'::jsonb,
        '["Pop","Hip-hop","Folk","Metal"]'::jsonb, 2),

    ((select id from cat), 'multiple_choice',
        'Какой композитор написал «Времена года»?',
        '"Fasllar" asarini qaysi bastakor yozgan?',
        'Who composed "The Four Seasons"?',
        '["Бах","Вивальди","Гайдн","Брамс"]'::jsonb,
        '["Bax","Vivaldi","Gaydn","Brams"]'::jsonb,
        '["Bach","Vivaldi","Haydn","Brahms"]'::jsonb, 1),

    ((select id from cat), 'true_false',
        'Группа ABBA из Швеции.',
        'ABBA guruhi Shvetsiyadan.',
        'ABBA is from Sweden.',
        '["Правда","Ложь"]'::jsonb, '["Rost","Yolg‘on"]'::jsonb, '["True","False"]'::jsonb, 0),

    ((select id from cat), 'multiple_choice',
        'Кто исполнил «Like a Rolling Stone»?',
        '"Like a Rolling Stone"ni kim ijro etgan?',
        'Who performed "Like a Rolling Stone"?',
        '["Леннон","Дилан","Спрингстин","Йорк"]'::jsonb,
        '["Lennon","Dilan","Springstin","Yorklar"]'::jsonb,
        '["Lennon","Dylan","Springsteen","York"]'::jsonb, 1),

    ((select id from cat), 'multiple_choice',
        'Сколько частей в классической симфонии (обычно)?',
        'Klassik simfoniyada (odatda) nechta qism bo‘ladi?',
        'How many movements does a classical symphony usually have?',
        '["2","3","4","5"]'::jsonb, '["2","3","4","5"]'::jsonb, '["2","3","4","5"]'::jsonb, 2),

    ((select id from cat), 'true_false',
        'Хип-хоп зародился в США в 1970-х.',
        'Xip-xop musiqasi AQShda 1970-yillarda paydo bo‘lgan.',
        'Hip-hop originated in the USA in the 1970s.',
        '["Правда","Ложь"]'::jsonb, '["Rost","Yolg‘on"]'::jsonb, '["True","False"]'::jsonb, 0),

    ((select id from cat), 'multiple_choice',
        'Какой инструмент главный в джазе?',
        'Jaz musiqasining asosiy cholg‘usi qaysi?',
        'Which instrument is iconic in jazz?',
        '["Скрипка","Саксофон","Аккордеон","Балалайка"]'::jsonb,
        '["Skripka","Saksofon","Akkordeon","Balalayka"]'::jsonb,
        '["Violin","Saxophone","Accordion","Balalaika"]'::jsonb, 1),

    ((select id from cat), 'multiple_choice',
        'Кто написал «Болеро»?',
        '"Bolero" asarini kim yozgan?',
        'Who composed "Boléro"?',
        '["Дебюсси","Равель","Сен-Санс","Берлиоз"]'::jsonb,
        '["Debyussi","Ravel","Sen-Sans","Berlioz"]'::jsonb,
        '["Debussy","Ravel","Saint-Saëns","Berlioz"]'::jsonb, 1),

    ((select id from cat), 'true_false',
        'Группа Pink Floyd известна альбомом «The Dark Side of the Moon».',
        'Pink Floyd guruhi "The Dark Side of the Moon" albomi bilan mashhur.',
        'Pink Floyd is famous for "The Dark Side of the Moon".',
        '["Правда","Ложь"]'::jsonb, '["Rost","Yolg‘on"]'::jsonb, '["True","False"]'::jsonb, 0);
