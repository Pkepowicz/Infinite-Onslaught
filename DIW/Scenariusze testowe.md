Testowany element|Procedura testowa|Oczekiwany wynik
-|-|-
Menu główne | Użytkownik wpisuje zbyt długą nazwe | Blokada możliwości wpisywania kolejnych znaków
Menu główne | Użytkownik nie może połączyć się z serwerem (np. nie ma internetu) | Pojawia się informacja o błędzie 
Menu główne | Użytkownik wcisnął przycisk "Dołącz do gry" | Znika menu główne i użytkownik zostaje przeniesiony na mape rozgrywki
Player object | Użytkownik wciska WSAD lub strzałki | Obiekt gracza się porusza na wszystkich klientach
Player object | Użytkownik wciska kilka razy lewy przycisk myszy | Obiekt gracza tworzy pocisk tylko jeśli upłynął odpowiednio długi czas od ostatniego strzału. Pocisk jest widoczny na wszystkich klientach
Player object | Użytkownik został trafiony przez pocisk innego gracza | Obiekt gracza zostaje odepchnięty od miejsca uderzenia, pojawiają się efekty cząsteczkowe i zmienia się kolor gracza. Zmiany są widoczne na wszystkich klientach
Serwer | Gra dobiegła końca | Wszystkie obiekty gracza zostają usunięte, pojawia się ekran z podsumowaniem i wynikami 3 najlepszych graczy
Player object | Punkty zdrowia gracza <= 0 | Obiekt gracza znika, pojawia się overlay z informacją za ile zostanie odrodzony. Gdy timer osiągnie 0 pojawia się nowy player object nad którym użytkownik ma kontrole
Network | Gra dobiegła końca gdy gracz był w ekranie odrodzenia | Znika ekran odrodzenia, procedura odradzania zostaje przerwana i pojawia się ekran podsumowania
Network | Użytkownik połączył się w czasie podsumowania | Użytkownik dostaje informacje że gra za niedługo się rozpocznie
