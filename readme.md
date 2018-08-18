# preproc
Препроцессор для модуля Import from text file в Digispot II DJin
================================================================
Roman Ermakov <r.ermakov@emg.fm>

v1.00 18.08.2018 - Initial release


Для модуля ["Импорт из текстового файла"][1] требуется текстовый файл в формате CSV. Если генератор музыкального или рекламного расписания выдаёт текстовый файл с полями фиксированной ширины, его необходимо преобразовать в формат с разделителями.

Данный препроцессор создан для преобразования формата "RCS Mediapilot" (см. образец [DF180817.txt](../blob/master/DF180817.txt)) в формат, пригодный для модуля импорта (см. образец [DF180817.out.txt](../blob/master/DF180817.txt))
Кроме этого:
* из исходного файла удаляются строки с пустым ID_number
* из исходного файла используются только поля Time, ID_number, Duration ,Date, Name.
* результирующий сохраняется в UTF-8

Препроцессор легко адаптируется под другие форматы с полями фиксированной ширины.

Для использования скопируйте `preproc.ps1` и `Media Pliot.fdl` в папку `\ROOT\IMP_FORMATS\` вашего ROOT-сервера или сконфигурируйте новый формат импорта, добавив `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy bypass -command "\\your-root-server\ROOT\IMP_FORMATS\preproc.ps1"` в параметры модуля.



[1]: https://redmine.digispot.ru/projects/digispot/wiki/%D0%98%D0%BC%D0%BF%D0%BE%D1%80%D1%82_%D0%BF%D0%BE_%D0%B8%D0%BC%D0%B5%D0%BD%D0%B8_%D1%84%D0%B0%D0%B9%D0%BB%D0%B0_%D0%B8%D0%B7_%D1%84%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2%D0%BE%D0%B9_%D1%81%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B_%D0%B2_%D1%83%D0%B6%D0%B5_%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D0%B9_%D1%88%D0%B0%D0%B1%D0%BB%D0%BE%D0%BD