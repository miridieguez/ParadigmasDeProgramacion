
% resultados reales
resultado(paises_bajos,3,estados_unidos, 1).
resultado(australia,1,argentina, 2).
resultado(polonia,3,francia, 1).
resultado(inglaterra,3,senegal, 0).
resultado(argentina,3,arabia, 3).


% pronosticos
pronostico(juan, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(juan, gano(argentina, australia, 3, 0)).
pronostico(juan, empataron(inglaterra, senegal, 0)).

pronostico(gus, gano(estados_unidos, paises_bajos, 1, 0)).
pronostico(gus, gano(japon, croacia, 2, 0)).

pronostico(lucas, gano(paises_bajos, estados_unidos, 3, 1)).
pronostico(lucas, gano(argentina, australia, 2, 0)).
pronostico(lucas, gano(croacia, japon, 1, 0)).

% 1.

% a) jugaron/3 Relaciona dos paises que hayan jugado un oartido y la diferencia de goles entre ambos.

jugaron(Pais, OtroPais, Diferencia):-
    resultadoDelPartido(Pais, OtroPais, Diferencia).
jugaron(Pais, OtroPais, Diferencia):-
    resultadoDelPartido(OtroPais, Pais, Diferencia).

resultadoDelPartido(Pais, OtroPais, Diferencia):-
    resultado(Pais, GolesPais, OtroPais, GolesOtroPais),
    Diferencia is GolesPais - GolesOtroPais.

% b) gano/2 Un pais le gano a otro si jugaron y el ganador metio mas goles que el otro

gano(PaisGanador,PaisPerdedor):-
    resultado(PaisGanador,GolesGanador,PaisPerdedor,GolesPerdedor),
    GolesGanador > GolesPerdedor.

% 2. puntosPronostico/2 
% 200 puntos si: acerto al ganador (o empate) y cantidad de goles
% 100 puntos si: acerto al ganador (o empate) y NO a la cant de goles
% 0 puntos si: no le pego a nati
puntosPronostico(Pronostico, Puntos):-
    puntosDeUnPronostico(Pronostico,Puntos).

% ACIERTA GANA
puntosDeUnPronostico(gano(Pais, OtroPais, Goles, OtrosGoles), Puntos):-
    jugaron(Pais, OtroPais,Diferencia),
    Diferencia \= 0,
    sumarONoPuntos(Pais, OtroPais, Goles, OtrosGoles, Puntos).

%ACIERTA PIERDE
puntosDeUnPronostico(perdio(Pais, OtroPais, Goles, OtrosGoles), Puntos):-
    jugaron(Pais, OtroPais,Diferencia),
    Diferencia \= 0,
    sumarONoPuntos(OtroPais, Pais, Goles, OtrosGoles, Puntos).

sumarONoPuntos(Pais, OtroPais, Goles, OtrosGoles, Puntos):-
    chequeoGoles(Pais, OtroPais, Goles, OtrosGoles, Puntos).
sumarONoPuntos(Pais, OtroPais, OtrosGoles, Goles, 100).

sumarONoPuntosEmpate(Pais, OtroPais, Goles, Puntos):-
    chequeoGolesEmpate(Pais, OtroPais, Goles, Puntos).
sumarONoPuntosEmpate(Pais, OtroPais, Goles, 100).

%ACIERTA EMPATE
puntosDeUnPronostico(empataron(Pais, OtroPais, Goles), Puntos):-
    empate(Pais,OtroPais),
    sumarONoPuntosEmpate(Pais, OtroPais, Goles, Puntos).

% CHEQUEA GOLES GANA O PIERDE
chequeoGoles(Pais, OtroPais, Goles, OtrosGoles, Puntos):-
    jugaron(Pais, OtroPais, Diferencia),
    Dif is Goles - OtrosGoles,
    Diferencia == Dif,
    Puntos is 200.

% CHEQUEA GOLES EMPATE
chequeoGolesEmpate(Pais, OtroPais, Goles, Puntos):-
    resultado(Pais,GolesDelEmpate,OtroPais,_),
    Goles == GolesDelEmpate,
    Puntos is 200.
chequeoGolesEmpate(Pais, OtroPais, Goles, Puntos):-
    resultado(OtroPais,GolesDelEmpate,Pais,_),
    Goles == GolesDelEmpate,
    Puntos is  200.

% SACA 0 PUNTOS
puntosDeUnPronostico(gano(Pais, OtroPais,_,_), Puntos):-
    jugaron(Pais,OtroPais,_),
    not(gano(Pais,OtroPais)),
    Puntos is 0.
puntosDeUnPronostico(perdio(Pais, OtroPais,_,_), Puntos):-
    jugaron(Pais,OtroPais,_),
    not(perdio(Pais,OtroPais)),
    Puntos is 0.
puntosDeUnPronostico(empataron(Pais, OtroPais,_,_), Puntos):-
    jugaron(Pais,OtroPais,_),
    not(empate(Pais,OtroPais)),
    Puntos is 0.


%AUX
perdio(Pais,OtroPais):-
    jugaron(Pais,OtroPais, Diferencia),
    Diferencia < 0.
empate(Pais,OtroPais):-
    jugaron(Pais,OtroPais, Diferencia),
    Diferencia = 0.

% 3. invicto/1
invicto(Persona):-
    pronostico(Persona,_),
    forall( (pronostico(Persona,Pronosticos),seJugoElPartido(Pronosticos)),
    (puntosDeUnPronostico(Pronosticos,Puntos),Puntos>=100 )).
    
seJugoElPartido(gano(Pais, OtroPais,_,_)):-
    jugaron(Pais,OtroPais,_).
seJugoElPartido(perdio(Pais, OtroPais,_,_)):-
    jugaron(Pais,OtroPais,_).
seJugoElPartido(empataron(Pais, OtroPais,_)):-
    jugaron(Pais,OtroPais,_).

% 4. puntaje/2
puntaje(Persona,Puntaje):-
    pronostico(Persona,_),
    findall(Puntos, (pronostico(Persona,Pronosticos), puntosDeUnPronostico(Pronosticos,Puntos)), ListaDePuntos),
    sum_list(ListaDePuntos, Puntaje).
    
% 5. favorito/1
favorito(Pais):-
    pronosticoDeUnPais(Pais,_),
    forall(pronosticoDeUnPais(Pais,Pronosticos), pronosticoGanador(Pais,Pronosticos)).
favorito(Pais):-
    jugaron(Pais,_,_),
    forall(jugaron(Pais,_,Diferencias), Diferencias>=3).

pronosticoDeUnPais(Pais, gano(Pais, OtroPais, Goles1, Goles2)) :- pronostico(_, gano(Pais, OtroPais, Goles1, Goles2)).
pronosticoDeUnPais(Pais, perdio(Pais, OtroPais, Goles1, Goles2)) :- pronostico(_, gano(Pais, OtroPais, Goles1, Goles2)).
pronosticoDeUnPais(Pais, empataron(Pais, OtroPais, Goles1)) :- pronostico(_, gano(Pais, OtroPais, Goles)).
pronosticoDeUnPais(Pais, empataron(OtroPais, Pais, Goles1)) :- pronostico(_, gano(OtroPais, Pais, Goles)).

pronosticoGanador(Pais,gano(Pais,_,_,_)).

