
# lastname
 
  Модуль для поиска фамилий, имен и отчеств по тексту; анализа и склонения фамилий имен и отчеств.

## Установка

```bash
   npm install lastname
```

  Вместе с модулем будет установлен coffee-script.
  

## API модуля
  Все обьекты, возвращаемые методами склонения и поиска людей имеют поле `found` в котором содержиться информация об исходном обьекте.


### Склонение имен

   Для методов `doInclineFemaleName`, `doInclineMaleName` склоняемые слова должны быть в именительном падеже.

```coffee-script
   sys = require "sys"
   ln = require "lastname"
   console.log ln.doInclineFemaleName "Василиса"
   console.log ln.doInclineMaleName "Василий"

   console.log ln.inclineName "Александром"        
   console.log ln.inclineName "Александрой"
```

### Склонение отчеств

```coffee-script
   sys = require "sys"
   ln = require "lastname"
   console.log ln.inclineMaleMiddleName "Григорьевича"
   console.log ln.inclineFemMiddleName "Арнольдовне"

   console.log ln.inclineMiddleName "Вячеславовича"
   console.log ln.inclineMiddleName "Андреевной"
```

### Склонение фамилий

```coffee-script
   sys = require "sys"
   ln = require "lastname"
   console.log ln.inclineFemaleSurname "Летящая"
   console.log ln.inclineFemaleSurname "Пробкиной"
   console.log ln.inclineMaleSurname "Грибков"
   console.log ln.inclineMaleSurname "Ильин"

   console.log ln.inclineSurname "Чичикова"
   console.log ln.inclineSurname "Кротких"
```

### Поиск людей
    
    Методу `findProperName` передается список из 1-3 склов. Допустимые комбинации
    - Фамилия
    - Имя Фамилия
    - Фамилия Имя Отчество
    - Имя Отчество Фамилия 
    Падеж передаваемых слов должен быть согласован.

```coffee-script
   sys = require "sys"
   ln = require "lastname"
   console.log ln.findProperName ["Алина", "Жилина"]
   console.log ln.findProperName ["Сольвьёв", "Василий"]

   console.log ln.findProperName ["Петром", "Васильевичем", "Старостиным"]
```

### Поиск по тексту

   Все имена и фамилии (парно), а так же имена, фамилии и отчества видаются в результирующем
   объекте с количеством найденных вхождений.

```coffee-script
   sys = require "sys"
   lastname = require "lastname"
   text = """ ,,,"""
   console.log "#{sys.inspect lastname.find"
```

## Командная строка
  
  Для добавление команды lastname необходимо установить пакет глобально:

```bash
        npm install lastname -g
```

  lastname может анализировать файлы 

```bash
        lastname -f file.txt
```

  и осуществлять поиск имен, фамилий и отчеств

```bash
        lastname Василий
        lastname Василий Тёркин
        lastname Василия Тёркина
        lastname Василии Петровиче Тёркине
```


## Как работает?
   Модуль опирается на словарь мужских и женских полных имен и правила склонения русского языка.
   В данный момент в словарь насчитывает 2346 мужских и 507 женских имен.

   lastname не обрабатывает двойные (Алим-Паша, Ахмед-оглы и т.п.) и уменьшительные имена (Юра, Вася, Петя, Лиза).
   Если полное имя отсутствует в модуле, напишите в issues.
   
   В некоторых случаях может быть неверно определено окончание, если трактовка склонения зависит только от ударения в слове.
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
