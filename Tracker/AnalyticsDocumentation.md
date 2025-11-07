# Аналитика AppMetrica

## Обзор
Проект интегрирован с YandexMobileMetrica для сбора аналитики согласно требованиям учебника.

## Настройка
- SDK подключен через Swift Package Manager
- API ключ: `52b59e67-56d9-4d95-b3a9-2369994c3166`
- Настроен в `AppDelegate.swift`
- AnalyticsManager предоставляет удобный интерфейс для отправки событий

## Проверка работы
В DEBUG режиме автоматически запускается полный тест аналитики:
- Проверка статуса SDK
- Отправка тестовых событий
- Логирование всех операций

## События

### Открытие/закрытие экрана
```swift
AnalyticsManager.shared.trackScreenOpen(screen: "Main")
AnalyticsManager.shared.trackScreenClose(screen: "Main")
```

### Тапы на кнопки
```swift
AnalyticsManager.shared.trackButtonClick(screen: "Main", item: "add_track")  // Кнопка добавления трекера
AnalyticsManager.shared.trackButtonClick(screen: "Main", item: "track")      // Тап на трекер
AnalyticsManager.shared.trackButtonClick(screen: "Main", item: "filter")    // Кнопка фильтров
AnalyticsManager.shared.trackButtonClick(screen: "Main", item: "edit")      // Редактирование в контекстном меню
AnalyticsManager.shared.trackButtonClick(screen: "Main", item: "delete")    // Удаление в контекстном меню
```

## Структура событий
Все события отправляются с параметрами:
- `event`: тип события ("open", "close", "click")
- `screen`: название экрана ("Main")
- `item`: тип элемента (только для событий "click")

## Тестирование
В DEBUG режиме автоматически вызывается `testAnalytics()` для проверки отправки всех событий.

## Логи
События логируются в консоль для отладки. В продакшене логи можно отключить.
