# Snake-in-Assembly (masm)
Acesta este jocul Snake facut in limbaj de asamblare. Am adaugat si framework-ul canvas care este necesar pentru vizualizarea jocului si olly debugger pentru a putea rula programul.

Din moment ce este olly debugger trebuie apasat:
  - F6 pentru a incepe un debug;
  - CTRL+F6 pentru a rula jocul;
  - CTRL+F7 pentru a-l compila;

Lucruri implementate:
- MISCARE: pentru a putea juca Snake trebuie sa dai click in partea de sus, jos, stanga sau dreapta a ferestrei ce se deschide cand rulezi programul pentru a putea schimba directia sarpelui (recomand sa se apase cat mai aproape de marginile ferestrei)
- ZIDURI: patratele negre sunt ziduri ce duc la sfarsitul jocului daca sarpele se izbeste de ele
- RESETAREA DIRECTIEI: cand sarpele atinge limita din stanga atunci acesta o sa continue din dreapta si vice versa. De asemenea, cand se atinge limita de sus sarpele o sa continue                        de jos si vice versa
- SE MANANCA PE EL INSUSI: cand schimbi directia nu ai voie sa fie fix cea opusa deoarece o sa se piara(ex. daca sarpele merge in sus nu poti sa il faci sa se miste in joc imediat, trebuie mai intai sa se duca in stanga sau in dreapta si dupa in jos; aceeasi regula se aplica pentru toate directiile)
- MANCAREA: sunt doua tipuri de mancare ( buna - galbena; rea - mov)
            1) daca o sa fie mancat un patrat galben atunci sarpele o sa creasca cu un patrat. De asemenea, daca mananci 10 patrate galbene jocul o sa fie castigat (conditie implementata pentru a castiga jocul - se poate schimba la linia 700 unde se poate scrie in loc de 10 orice numar se doreste)
            2) daca se mananca un patrat mov atunci corpul sarpelui o sa scada cu un patrat. De asemena, daca se mananca un patrat mov fara sa se fi mancat niciun patrat galben jocul o sa fie pierdut deoarece scorul incepe de la 0 si scorul nu poate sa fie negativ
            3) coordonatele pentru ambele feluri de mancare sunt generate aleator
