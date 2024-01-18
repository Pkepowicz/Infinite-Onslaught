Przyciągający pocisk
## Pola
| Nazwa | Typ | Opis |
| ---- | ---- | ---- |
| speed | float | prędkość pocisku |
| direction | Vector2 | kierunek pocisku |
| parent | Node | właściciel obiektu |
| knockback_force | float | siła odrzutu |
| damage | int | obrażenia pocisku |
## Metody 
| Zwracany Typ | Nazwa i Argumenty | Opis |
| ---- | ---- | ---- |
| void | _process() | Funkcja wywoływana w każdej klatce, porusza pociskiem oraz wykrywa innych graczy w zasięgu i przyciąga ich do siebie |
| void | delete_on_timer(float) | Usuwa ten obiekt po podanym czasie |
