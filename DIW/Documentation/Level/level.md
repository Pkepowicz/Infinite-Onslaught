Ten skrypt obecny jest w każdym poziomie i odpowiada za obiekty na mapie

## Pola
| Nazwa | Typ | Opis |
| ---- | ---- | ---- |
| spawn_points | Array[SpawnPoint] | Lista wszystkich spawn pointów na danym poziomie |
## Metody
| Zwracany Typ | Nazwa i Argumenty | Opis |
| ---- | ---- | ---- |
| Vector2 | get_spawn() | Zwraca pozycję losowo wybranego spawn pointu z listy spawn_points |