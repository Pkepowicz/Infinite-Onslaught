Zwykły pocisk
## Pola
| Nazwa | Typ | Opis |
| ---- | ---- | ---- |
| SPEED | float | prędkość pocisku, stała |
| direction | Vector2 | kierunek pocisku |
| parent | Node | właściciel obiektu |
| knockback_force | float | siła odrzutu |
| damage | int | obrażenia pocisku |
## Metody 
| Zwracany Typ | Nazwa i Argumenty | Opis |
| ---- | ---- | ---- |
| void | _physics_process() | Funkcja wywoływana w każdej klatce, porusza pociskiem |
| void | delete_on_timer(float) | Usuwa ten obiekt po podanym czasie |
