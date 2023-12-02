%persona(Apodo, Edad, Peculiaridades).
persona(ale, 15, [claustrofobia, cuentasRapidas, amorPorLosPerros]).
persona(agus, 25, [lecturaVeloz, ojoObservador, minuciosidad]).
persona(fran, 30, [fanDeLosComics]).
persona(rolo, 12, []).

%esSalaDe(NombreSala, Empresa).
esSalaDe(elPayasoExorcista, salSiPuedes).
esSalaDe(socorro, salSiPuedes).
esSalaDe(linternas, elLaberintoso).
esSalaDe(guerrasEstelares, escapepepe).
esSalaDe(fundacionDelMulo, escapepepe).
esSalaDe(estrellasDePelea,supercelula). %PUNTO 6
esSalaDe(choqueDeLaRealeza,supercelula). %PUNTO 6
esSalaDe(miseriaDeLaNoche,sKPista). %PUNTO 6
esSalaDe(facil,facilin).%la agrego para hacer test

%terrorifica(CantidadDeSustos, EdadMinima).
%familiar(Tematica, CantidadDeHabitaciones).
%enigmatica(Candados).

%sala(Nombre, Experiencia).
sala(elPayasoExorcista, terrorifica(100, 18)).
sala(socorro, terrorifica(20, 12)).
sala(linternas, familiar(comics, 5)).
sala(facil,familiar(videojuegos,1)). %la agrego para hacer test
sala(guerrasEstelares, familiar(futurista, 7)).
sala(fundacionDelMulo, enigmatica([combinacionAlfanumerica, deLlave, deBoton])).
sala(estrellasDePelea, familiar(videojuegos, 7)). %PUNTO 6
sala(miseriaDeLaNoche, terrorifica(150, 21)). %PUNTO 6

%nivelDeDificultadDeLaSala/2: para cada sala nos dice su dificultad. 

%Para las salas de experiencia terrorífica el nivel de dificultad es la cantidad de sustos menos 
%la edad mínima para ingresar.
nivelDeDificultadDeLaSala(Sala,Nivel):-
    sala(Sala,terrorifica(Sustos,Edad)),
    Nivel is (Sustos-Edad).

%Para las de experiencia familiar es 15 si es de una temática futurista y 
%para cualquier otra temática es la cantidad de habitaciones.
nivelDeDificultadDeLaSala(Sala,15):-
    sala(Sala,familiar(futurista,_)).

nivelDeDificultadDeLaSala(Sala,Nivel):-
    sala(Sala,familiar(T,Nivel)),
    T\=futurista.

%El de las enigmáticas es la cantidad de candados que tenga.
nivelDeDificultadDeLaSala(Sala,Nivel):-
   sala(Sala,enigmatica(Candados)),
   length(Candados, Nivel).
   
claustrofobica(Persona):-
    persona(Persona,_,Peculiaridades),
    member(claustrofobia,Peculiaridades).

%puedeSalir/2: una persona puede salir de una sala si no es claustrofóbica y la dificultad de la sala es 1

puedeSalir(Persona,Sala):-
    persona(Persona,_,_),
    not(claustrofobica(Persona)),
    nivelDeDificultadDeLaSala(Sala,Nivel),
    Nivel=1.


%si tiene más de 13 años y no es claustrofóbica y la dificultad es menor a 5 
puedeSalir(Persona,Sala):-
    persona(Persona,Edad,_),
    Edad>13,
    not(claustrofobica(Persona)),
    nivelDeDificultadDeLaSala(Sala,Nivel),
    Nivel<5.


%tieneSuerte/2: una persona tiene suerte en una sala si puede salir de ella aún sin tener ninguna peculiaridad
tieneSuerte(Persona,Sala):-
    persona(Persona,_,[]),
    puedeSalir(Persona,Sala).


%esMacabra/1: una empresa es macabra si todas sus salas son de experiencia terrorífica.
%esMacabra(Empresa):-
   %esSalaDe(_, Empresa),
   %forall(esSalaDe(Sala, Empresa),sala(Sala,terrorifica(_,_))).

esMacabra(Empresa):-
    esSalaDe(_, Empresa),
   not((esSalaDe(Sala, Empresa),not(sala(Sala,terrorifica(_,_))))).

%empresaCopada/1: una empresa es copada si no es macabra y el promedio de dificultad de sus salas es menor
%a 4.

empresaCopada(Empresa):-
    esSalaDe(_, Empresa),
    not(esMacabra(Empresa)),
    promedioDificultades(Empresa,Promedio),
    Promedio<4.

cantidadDeSalas(Empresa,Cantidad):-
    esSalaDe(_, Empresa),
    findall(Sala, esSalaDe(Sala, Empresa), Salas),
    length(Salas,Cantidad).

cantidadDeDificultad(Empresa,Cantidad):-
    esSalaDe(_, Empresa),
    findall(Dificultad, (esSalaDe(Sala, Empresa),nivelDeDificultadDeLaSala(Sala,Dificultad)), Dificultades),
    sum_list(Dificultades,Cantidad).

promedioDificultades(Empresa,Promedio):-
    cantidadDeSalas(Empresa,Cantidad),
    cantidadDeDificultad(Empresa,Dificultad),
    Promedio is (Dificultad/Cantidad).

%La empresa supercelula es dueña de salas de escape familiares ambientadas en videojuegos. 
%La sala estrellasDePelea cuenta con 7 habitaciones 
%pero lamentablemente no sabemos la cantidad que tiene su nueva sala choqueDeLaRealeza. no la agrego en la clausula sala
%La empresa SKPista (fanática de un famoso escritor) es la dueña de una única sala
%terrorífica para mayores de 21
%llamada miseriaDeLaNoche que nos asegura 150 sustos.
%La nueva empresa que se suma a esta gran familia es Vertigo, pero aún no cuenta con salas. no la agrego 
