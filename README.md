# ProBeauty Space - Garmin Forerunner 965 App

Приложение для отображения данных из API ProBeauty Space на часах Garmin Forerunner 965.

## Структура проекта

```
ProBeautySpace/
├── manifest.json          # Конфигурация приложения
├── monkey.jungle          # Файл сборки
├── source/
│   └── App.mc            # Основной код приложения
├── resources/
│   └── strings.xml       # Строки локализации
├── resources-fonts/      # Шрифты (опционально)
├── resources-drawables/  # Изображения (опционально)
└── README.md            # Документация
```

## Функциональность

- 📡 Запрос данных к API: `https://apidev.probeautyspace.ru/garmin/`
- 📊 Отображение имени и цены по центру экрана
- 🔄 Обновление данных по нажатию кнопки Select
- ⚠️ Обработка ошибок сети и данных
- 🎯 Оптимизировано для Garmin Forerunner 965

## Сборка и установка

1. Установите Garmin Connect IQ SDK
2. Соберите приложение:
   ```bash
   monkeyc -f monkey.jungle -o ProBeautySpace.prg -y developer_key.der
   ```
3. Установите через Garmin Connect IQ Mobile App

## API Формат

Ожидаемый JSON ответ:
```json
[{"name":"JTO","price":1.123}]
```

## Управление

- **Select**: Обновить данные
- **Back**: Выйти из приложения
