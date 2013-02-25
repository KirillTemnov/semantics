
# semantics

  Статистический и семантический анализ текста.
 
## Установка

```bash
   npm install semantics
```



## API модуля



  Все обьекты, возвращаемые методами склонения и поиска людей имеют поле `found` в котором содержиться информация об исходном обьекте.


### Склонение имен

   Для методов `doInclineFemaleName`, `doInclineMaleName` склоняемые слова должны быть в именительном падеже.

```coffee-script
   sem = require "semantics"
   console.log sem.plugins.ru.inclines.doInclineFemaleName "Василиса"
   console.log sem.plugins.ru.inclines.doInclineMaleName "Василий"

   console.log sem.plugins.ru.inclines.inclineName "Александром"
   console.log sem.plugins.ru.inclines.inclineName "Александрой"
```

### Склонение отчеств

```coffee-script
   sem = require "semantics"
   console.log sem.plugins.ru.inclines.inclineMaleMiddleName "Григорьевича"
   console.log sem.plugins.ru.inclines.inclineFemMiddleName "Арнольдовне"

   console.log sem.plugins.ru.inclines.inclineMiddleName "Вячеславовича"
   console.log sem.plugins.ru.inclines.inclineMiddleName "Андреевной"
```

### Склонение фамилий

```coffee-script
   sem = require "semantics"
   console.log sem.plugins.ru.inclines.inclineFemaleSurname "Летящая"
   console.log sem.plugins.ru.inclines.inclineFemaleSurname "Пробкиной"
   console.log sem.plugins.ru.inclines.inclineMaleSurname "Грибков"
   console.log sem.plugins.ru.inclines.inclineMaleSurname "Ильин"

   console.log sem.plugins.ru.inclines.inclineSurname "Чичикова"
   console.log sem.plugins.ru.inclines.inclineSurname "Кротких"
```

### Подбор фамилий, имен и отчеств людей
    
    Методу `findProperName` передается список из 1-3 слов. Допустимые комбинации
    - Фамилия
    - Имя Фамилия
    - Фамилия Имя Отчество
    - Имя Отчество Фамилия 
    Падеж передаваемых слов должен быть согласован.

```coffee-script
   sem = require "semantics"
   console.log sem.plugins.ru.inclines.findProperName ["Алина", "Жилина"]
   console.log sem.plugins.ru.inclines.findProperName ["Сольвьёв", "Василий"]

   console.log sem.plugins.ru.inclines.findProperName ["Петром", "Васильевичем", "Старостиным"]
```

* Все имена и фамилии в примерах являются плодами моей фантазии, любые совпадения случайны.



## Анализ текста

   Для анализа текста используется вызов функции `semantics.analysis.analyse` и передача ей   
   в качестве аргумента текста и списка плагинов для анализа текста. Если список плагинов пуст,
   используются анализаторы по умолчанию. В результате анализа возвращается объект, содержащий
   параметры текста. Набор параметров зависит от плагинов, подробности в описаниях.


```coffee-script
   sys = require "util"
   semantics = require "semantics"
   text = """Любой текст для анализа, английский тоже подойдет"""
   console.log "#{sys.inspect semantics.analysis.analyse text}"
   # результат:
    { misc: 
       { digits: {},
         emoticons: {},
         romans: {},
         sentences: [ 'Любой текст для анализа , английский тоже подойдет .' ] },
      counters: 
       { chars_total: 49,
         words_total: 7,
         signs_total: 1,
         spaces_total: 6,
         word_length_mid: 6,
         words_in_sentence_mid: 7 },
      }
```



### Поиск в файле

```coffee-script
   sys = require "util"
   semantics = require "semantics"
   console.log semantics.analyseFile "/tmp/sample.txt"
```

* Поиск в файле и по тексту возвращает пустой словарь `{}` если не было найдено ни одного совпадения.


## Командная строка
  
  Для добавление команды semantics необходимо установить пакет глобально:

```bash
        npm install semantics -g
```

  semantics может анализировать файлы 

```bash
        semantics -a file.txt
```

  Склонять прилагательные

```bash
        semantics -i Стильные
```

  осуществлять поиск имен, фамилий и отчеств

```bash
        semantics Василий
        semantics Василий Тёркин
        semantics Василия Тёркина
        semantics Василии Петровиче Тёркине
```

## Плагины

Плагины размещаются в plugins.LANG относительно остальных модулей. LANG - язык для которого
предназначен плагин, например, ru, en.

Плагин должен иметь функцию `preFilter` или `postFilter`. 
Функции `preFilter` и `postFilter` принимают 3 параметра: 

1) `text` - Анализируемый текст. Текст не может быть модифицирован.

2) `result` - Результирующий объект. Каждый плагин может добавлять свои ключи к объекту. Перезапись данных других плагинов не рекомендуется.

3) `opts` - опции. Этот параметр содержит опции для всех плагинов. Плагины не должны
модифицировать этот объект.

В процессе анализа текста вначале вызываются все функции `preFilter`, затем `postFilter`.

Плагины могут быть использованы самостоятельно либо собраны в цепочку, см. модуль `semantics.analysis`.

### Встроенные плагины

#### `plugins.ru.abbrevs` Модуль для извлечения русских и английских аббревиатур из текста.
     
Функции:

a) `preFilter` - Извлекает аббревиатуры из текста и помещает словарь с аббревиатурами и частотой вхождения в `result.ru.abbrevs`.

b) `extract` Принимает текст в качестве параметра, возвращает список аббревиатур (с дубликатами).

```coffee-script
    sem = require "semantics"
    sem.plugins.ru.abbrevs.extract "текст с НЕКОЙ аббревиатурой" #  [ 'НЕКОЙ' ]
```

#### `plugins.ru.meaning` Получение связанных фраз из текста, уменьшение длинны исходного текста.

     

#### `plugins.ru.quotes` Получение цитат из текста. Фактически извлекает любой текст в кавычках.

Функции:

`preFilter` - Извлекает цитаты из текста и помещает их в список `result.quotes`.

`getQuotes` - Принимает текст в качестве параметра, возвращает список цитат (с дубликатами). 

```coffee-script
    > sem  = require "semantics"
    > sem.plugins.ru.quotes.getQuotes ' "Ты всегда можешь найти утешение в примитиве." Поль Гоген'
    [ '"Ты всегда можешь найти утешение в примитиве."' ]
```

            

#### `plugins.ru.dates` Русские даты и интервалы дат.

Функции:

`preFilter` - Извлекает даты из текста и помещает их в словари `result.dates` и `result.intervals`. В `result.data_sourses` помещаются строки, соответствующие найденным датам.

`extractDates` - Принимает строку или список строк как параметр, возвращает объект с атрибутами `dates`, `sources`, `intervals`. Пример:

```coffee-script
    > sem  = require "semantics"
    > z1  = sem.plugins.ru.dates.extractDates "Сегодня, 12 сентября 2015 года, я из лесу вышел."
    { intervals: {},
      dates: { '12.09.2015': { count: 1, value: { y: 2015, d: 12, m: 8 } } },
      sources: [ '12 сентября 2015', [length]: 1 ] }

    > z2  = sem.plugins.ru.dates.extractDates "Сегодня, 12 сентября 2015 года, я из лесу вышел. Был в походе с 1 сентября по 12 сентября 2015 года."
    { intervals: 
       { '01.09.2015-12.09.2015': 
          { to_value: { y: 2015, d: 12, m: 8 },
            from_value: { y: 2015, d: 1, m: 8 },
            from: '01.09.2015',
            count: 1,
            to: '12.09.2015' } },
      dates: {},
      sources: [ ' 1 сентября по 12 сентября 2015 ', [length]: 1 ] }
```                       

`packDates` - "Упаковать" даты. Формирует компактное представление из дат, полученных с помощью `extractDates`.

```coffee-script
    > sem.plugins.ru.dates.packDates z1.dates 
    { '12.09.2015': 1 }
```

`packIntervals` - "Упаковать" интервалы дат. Формирует компактное представление из интервалов дат, полученных с помощью `extractDates`.

```coffee-script
    > sem.plugins.ru.dates.packDates z2.intervals
    { '01.09.2015-12.09.2015': 1 }
```


#### `plugins.ru.inclines`

#### `plugins.ru.propernames`

#### `plugins.ru.ref`

#### `plugins.ru.words`

#### `plugins.ru.twitter`



## Как работает?
   Модуль опирается на словарь мужских и женских полных имен и правила склонения русского языка.
   В данный момент в словарь насчитывает 2346 мужских и 507 женских имен.

   semantics пока не обрабатывает двойные (Алим-Паша, Ахмед-оглы и т.п.) и уменьшительные имена (Юра, Вася, Петя, Лиза).
   Если полное имя отсутствует в модуле, напишите в issues.
   
   В некоторых случаях может быть неверно определено окончание, если трактовка склонения зависит только от ударения в слове.

   При поиске фамилий и имен может быть некорректно определен пол для случаев, зависящих от контекста.


### Пример
    "Валентина Петрова" - именительный падеж, женский род.
    "Валентина Петрова" - родительный, винительный падежи, мужской род.

    "Валентину Петрову" - винительный падеж, женский род.
    "Валентину Петрову" - дательный падеж, мужской род.
   
##
   
## Лицензия MIT

(The MIT License)

Copyright (c) 2011-2013 Temnov Kirill &lt;allselead@gmail.com&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
