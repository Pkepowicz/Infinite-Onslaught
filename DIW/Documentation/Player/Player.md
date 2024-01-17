Skrypt gracza
## Pola
| Nazwa | Typ | Opis |
| ---- | ---- | ---- |
| SPEED | float | prędkość gracza, stała |
| id | int | identyfikator gracza |
| username | String | nazwa gracza |
| basic_bullet | PackedScene | obiekt bazowego pocisku |
| bullet | PackedScene | obiekt pocisku, może się różnić od bazowego |
|  |  |  |
## Metody 
| Zwracany Typ | Nazwa i Argumenty | Opis |
| ---- | ---- | ---- |
| void | update_label() | ustawia tekst nad głową gracza na jego username |
| void | _physics_process(delta) | funkcja wywoływana w każdej klatce, odpowiada za ruch gracza, jego obrót i wykrywanie próby strzelania |
| void | Fire() | tworzy nową instancję pocisku i nadaje mu odpowiednie parametry |
| void | _on_hit_box_update_color_signal(Color) | ustawia nowy kolor na otrzymany od [[hit_box]] oraz emituje efekty otrzymania obrażen |
| void | _on_hit_box_get_knocked_back(Vector2) | Odrzuca gracza o wartość przekazaną z [[hit_box]] |
| void | _on_hit_box_player_death(Node) | przetwarza informacje o śmierci gracza, takie jak dodanie punktów ostatniej osobie która zadała obrażenia i usuwa obiekt gracza |
