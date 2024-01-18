Statyczny menadżer, służy do zarządzania wszystkimi kafelkami lawy

## Pola()
| Nazwa | Typ | Opis |
| ---- | ---- | ---- |
| tiles | Array[LavaTile] | Lista wszystkich [[LavaTile]] |
| damage | [[Damage]] | Obiekt obrażen, który jest zadawany graczom |

## Metody
| Zwracany Typ | Nazwa i Argumenty | Opis |
| ---- | ---- | ---- |
| void | _on_timer_timeout() | zadaje podane obrażenia wszystkim graczon w swoim obszarze, kiedy skończy się odliczanie |
