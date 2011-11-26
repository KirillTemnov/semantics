
# lastname

  Статистический анализ текста. Склонение русских имен, фамилий и отчеств.
 
## Установка

```bash
   npm install lastname
```

  Вместе с библиотекой будет установлен coffee-script.



## API модуля
  Все обьекты, возвращаемые методами склонения и поиска людей имеют поле `found` в котором содержиться информация об исходном обьекте.


### Склонение имен

   Для методов `doInclineFemaleName`, `doInclineMaleName` склоняемые слова должны быть в именительном падеже.

```coffee-script
   ln = require "lastname"
   console.log ln.plugins.ru.inclines.doInclineFemaleName "Василиса"
   console.log ln.plugins.ru.inclines.doInclineMaleName "Василий"

   console.log ln.plugins.ru.inclines.inclineName "Александром"
   console.log ln.plugins.ru.inclines.inclineName "Александрой"
```

### Склонение отчеств

```coffee-script
   ln = require "lastname"
   console.log ln.plugins.ru.inclines.inclineMaleMiddleName "Григорьевича"
   console.log ln.plugins.ru.inclines.inclineFemMiddleName "Арнольдовне"

   console.log ln.plugins.ru.inclines.inclineMiddleName "Вячеславовича"
   console.log ln.plugins.ru.inclines.inclineMiddleName "Андреевной"
```

### Склонение фамилий

```coffee-script
   ln = require "lastname"
   console.log ln.plugins.ru.inclines.inclineFemaleSurname "Летящая"
   console.log ln.plugins.ru.inclines.inclineFemaleSurname "Пробкиной"
   console.log ln.plugins.ru.inclines.inclineMaleSurname "Грибков"
   console.log ln.plugins.ru.inclines.inclineMaleSurname "Ильин"

   console.log ln.plugins.ru.inclines.inclineSurname "Чичикова"
   console.log ln.plugins.ru.inclines.inclineSurname "Кротких"
```

### Подбор фамилий, имен и отчеств людей
    
    Методу `findProperName` передается список из 1-3 слов. Допустимые комбинации
    - Фамилия
    - Имя Фамилия
    - Фамилия Имя Отчество
    - Имя Отчество Фамилия 
    Падеж передаваемых слов должен быть согласован.

```coffee-script
   ln = require "lastname"
   console.log ln.plugins.ru.inclines.findProperName ["Алина", "Жилина"]
   console.log ln.plugins.ru.inclines.findProperName ["Сольвьёв", "Василий"]

   console.log ln.plugins.ru.inclines.findProperName ["Петром", "Васильевичем", "Старостиным"]
```

* Все имена и фамилии в примерах являются плодами моей фантазии, любые совпадения случайны.



### Анализ текста

   Для анализа текста используется вызов функции `lastname.analysis.analyse` и передача ей   
   в качестве аргумента текста и списка плагинов для анализа текста. Если список плагинов пуст,
   используются анализаторы по умолчанию. В результате анализа возвращается объект, содержащий
   параметры текста. Набор параметров зависит от плагинов, подробности в описаниях.


```coffee-script
   sys = require "util"
   lastname = require "lastname"
   text = """Любой текст для анализа, английский тоже подойдет"""
   console.log "#{sys.inspect lastname.analysis.analyse text}"
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
      version: '0.3.XX }
```

### Поиск в файле

```coffee-script
   sys = require "util"
   lastname = require "lastname"
   console.log lastname.analyseFile "/tmp/sample.txt"
```

* Поиск в файле и по тексту возвращает пустой словарь `{}` если не было найдено ни одного совпадения.


## Командная строка
  
  Для добавление команды lastname необходимо установить пакет глобально:

```bash
        npm install lastname -g
```

  lastname может анализировать файлы 

```bash
        lastname -a file.txt
```

  Склонять прилагательные

```bash
        lastname -i Стильные
```

  осуществлять поиск имен, фамилий и отчеств

```bash
        lastname Василий
        lastname Василий Тёркин
        lastname Василия Тёркина
        lastname Василии Петровиче Тёркине
```

## Плагины

   ...   

## Как работает?
   Модуль опирается на словарь мужских и женских полных имен и правила склонения русского языка.
   В данный момент в словарь насчитывает 2346 мужских и 507 женских имен.

   lastname не обрабатывает двойные (Алим-Паша, Ахмед-оглы и т.п.) и уменьшительные имена (Юра, Вася, Петя, Лиза).
   Если полное имя отсутствует в модуле, напишите в issues.
   
   В некоторых случаях может быть неверно определено окончание, если трактовка склонения зависит только от ударения в слове.

   При поиске фамилий и имен может быть некорректно определен пол для 


### Пример
    "Валентина Петрова" - именительный падеж, женский род.
    "Валентина Петрова" - родительный, винительный падежи, мужской род.

    "Валентину Петрову" - винительный падеж, женский род.
    "Валентину Петрову" - дательный падеж, мужской род.
   
##
   
## Лицензия MIT

(The MIT License)

Copyright (c) 2011 Temnov Kirill &lt;allselead@gmail.com&gt;

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
