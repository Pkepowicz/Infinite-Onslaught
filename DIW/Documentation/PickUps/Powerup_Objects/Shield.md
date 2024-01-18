Obiekt, który jest podpinany do gracza aby wywołać efekt tarczy

## Pola
| Nazwa | Typ | Opis |
| ---- | ---- | ---- |
| float | immunity_time | Czas niewrażliwości w sekundach |
## Metody 
| Zwracany Typ | Nazwa i Argumenty | Opis |
| ---- | ---- | ---- |
| void | _ready() | Od razu po stworzeniu sprawia że gracz staje się niewrażliwy i odpala timer, po którego upływie niewrażliwość jest zdejmowana |
| void | end_immunity_time() | Kończy niewrażliwość na obrażenia |
