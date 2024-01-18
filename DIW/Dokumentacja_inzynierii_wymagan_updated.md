# Macierz Kompetencji Zespołu

Kompetencje|Dominik Dziechciarz|Paweł Kępowicz
-|-|-
Programowanie GDScript|Posiada|Posiada
Networking|Nie posiada|Posiada (podstawy)
Game Design|Posiada (podstawy)|Posiada
Umiejętności graficzne|Nie posiada|Nie posiada
Testowanie Oprogramowania|Nie posiada|Nie posiada
System Design|Posiada (podstawy)|Posiada (podstawy)
Oracle cloud|Posiada (podstawy)|Posiada (podstawy)
# Pytania odnośnie projektu
Pytanie|Odpowiedź|Uwagi
-|-|-
Ile trwa rozgrywka?|5 minut na rundę| -
Jak gracz włącza grę?|Poprzez wejście na odpowiedni adres w przeglądarce| -
Czy coś pomiędzy rozgrywkami będzie się zapisywać | Nie, każda rozgrywka jest niezależna od pozostałych | -
Czy użytkownicy będą mieć swoje konta| Nie, chcemy wymagać od użytkownika jak najmniej | -
Czy gra będzie płatna?|Nie, będzie całkowicie darmowa| -

# Założenia gry
## Grafika
 Gra 2D typu top down z minimalistyczną grafiką. Przykład:![img](img1.png)
 [Long Tail](https://rkamil.itch.io/long-tail)![img](img2.png)
 [ICE](https://play.google.com/store/apps/details?id=com.queader.ice&hl=en&pli=1)
 
## Rozgrywka
 Główną inspiracją przy tworzeniu gry jest Quake 2 i Super Smash Bros. Zasady mają być proste, do zrozumienia w czasie pierwszych 10 minut rozgrywki. Gracz ma możliwość poruszania się swoją postacią, podstawowego ataku i możliwość podnoszenia zaawansowanych broni. Każda zadaje określoną liczbę punktów obrażeń i odpycha trafiony cel. Rozgrywka powinna być szybka, a system podnoszenia silniejszych broni ma zmuszać graczy do agresywnych zagrań w duchu Quake'a. Walka toczy się na ograniczonym terenie i najskuteczniejszym sposobem eliminacji powinno być wypchnięcie przeciwnika z areny. 
## Rywalizacja
 Gracze rywalizują w meczach trwających 2 minuty. Zwycięzcą danej rundy zostaje gracz który zdobył najwięcej eliminacji. Po zakończeniu meczu jest krótka przerwa z podsumowaniem i automatycznie rozpoczyna się nowa gra.
# Projekt architektury opracowanego systemu
![[img5.png]]
Użytkownik musi pobrać najnowszą wersje gry z odpowiedniego hostingu po czym może połączyć się z serwerem i rywalizować z innymi graczami. 

# Sugerowane rozwiązania
### Silnik gry: Godot
 Uzasadnienie: Członkowie zespołu posiadają doświadczenie w tworzeniu gier z wykorzystaniem tego silnika, dodatkowo Godot posiada opcje wysokopoziomowej obsługi połączeń i synchronizacji rozgrywki co znacznie ułatwi prace nad projektem. Umożliwia on eksportowanie projektu za pomocą WebGL co pozwoli na wykorzystanie przeglądarki do rozgrywki
### Hosting: itch.io
 Uzasadnienie: Bardzo popularna platforma do udostępniania swoich projektów związanych z gamedevem. Oferuje wszystko czego potrzebujemy aby rozdystrybuować projekt do szerokiego grona odbiorców za darmo.
### Chmura: Oracle cloud
 Uzasadnienie: Wszyscy członkowie zespołu są zaznajomieni z chmurą Oracle która oferuje wszystkie opcje potrzebne do zrealizowania projektu za darmo.
### Diagram Sekwencji
![img](img4.png)
