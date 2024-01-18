Skrypt odpowiedzialny za dołączanie graczy i zarządzanie grą
## Pola
| Nazwa | Typ | Opis |
| ---- | ---- | ---- |
| game_length | int | czas gry w sekundach |
| player_respawn_time | int | czas ponownego pojawienia się graczy po śmierci |
| PORT | int | stała wartość, port serwera |
| is_game_over | bool | aktualny stan gry |
|  |  |  |
## Metody 
| Zwracany Typ | Nazwa i Argumenty | Opis |
| ---- | ---- | ---- |
| void | _ready() | Jeżeli plik został wywołany z flagą --server startuje jako serwer |
| void | _process() | wywoływane w każdej klatce, zbiera i rozsyła informacje o graczach i grze |
| void | host_server | tworzy serwer w instancji gracza |
| void | _on_join_buton_down() | po kliknięciu przycisku join dołącza do serwera o podanym adresie ip |
| void | add_player(peer_id) | dodaje gracza do gry i spawnuje go za pomocą funkcji create_player |
| void | create_player() | tworzy obiekt gracza w losowo wybranym [[spawn_point]] |
| void | remove_player() | usuwa gracza i jego obiekt z gry |
| void | sync_player_info() | aktualizuje stan graczy między nimi |
| void | respawn_player() | tworzy nowy obiekt gracza po jego śmierci |
| void | show_starting_screen() | pokazuje startowy ekran |
| void | hide_starting_screen() | chowa startowy obraz |
| void | restart_game() | restartuje grę po pływie czasu gry |
| void | _on_host_button_down() | po wciśnięciu przycisku host wywołuje funkcję host_server() |
