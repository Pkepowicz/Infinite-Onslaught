Obiekt odpowiedzialny za przetrzymywanie informacji o zdrowiu i otrzymywaniu obrażeń

## Pola
| Nazwa | Typ | Opis |
| ---- | ---- | ---- |
| max_hp | int | maksymalna ilość zdrowia |
| hp | int | aktualna wartość zdrowia |
| parent | Node | właściciel obiektu |
| immune | bool | czy gracz jest niewrażliwy na obrażenia |
| last_hit | Node | referecja do ostatniego obiektu który zadał obrażenia |
## Metody 
| Zwracany Typ | Nazwa i Argumenty | Opis |
| ---- | ---- | ---- |
| void | take_damage([[Damage]]) | Przetwarza dane o otrzymanych obrażeniach, |
| void | update_color() | Wybiera nowy kolor na podstawie brakującego zdrowia i wysyła go sygnałem do [[Player]] |
