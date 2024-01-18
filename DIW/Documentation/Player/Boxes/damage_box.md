obiekt odpowiedzialny za zadawanie obrażen

## Pola
| Nazwa | Typ | Opis |
| ---- | ---- | ---- |
| parent | Node | właściciel tego obiektu |
| damage | int | ilość obrażen zadawanych |
| knockback_force | float | siła odrzutu |
## Metody 
| Zwracany Typ | Nazwa i Argumenty | Opis |
| ---- | ---- | ---- |
| void | set_parent(Node) | Przypisuje właściciela obiektu |
| void | deal_damage(Area2D) | Zadaje obrażenia obiektowi |
| void | _on_area_2d_area_entered(area) | Wykrywa kolzicje z obiektami, jeżeli jest to [[hit_box]] innego gracza wywołuje funkcję deal_damage |
