Punkt startowy, na którym gracze pojawiają się po dołączeniu do gry i po śmierci

## Pola 
| Nazwa | Typ | Opis |
| ---- | ---- | ---- |
| spawn_prevention_radius | float | Jeżeli inny gracz znajduje się w tym promieniu nie będzie możliwe pojawienie się na tym punkcie |
| spawn_prevention | bool | Każdy spawn point ma czas odnowienia, podczas którego nie może pojawić się na nim kolejny gracz |
## Metody
| Zwracany Typ | Nazwa i Argumenty | Opis |
| ---- | ---- | ---- |
| bool | can_spawn_here() | Zwraca, czy gracz może pojawić się na tym punkcie |