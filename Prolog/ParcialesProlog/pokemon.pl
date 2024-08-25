
% Modelo inicial
pokemon(pikachu,electrico).
pokemon(charizard,fuego).
pokemon(venusaur,planta).
pokemon(blastoise,agua).
pokemon(totodile,agua).
pokemon(snorlax,normal).
pokemon(rayquaza,dragon).
pokemon(rayquaza,volador).

entrena(ash,pikachu).
entrena(ash,charizard).
entrena(brock,snorlax).
entrena(misty,blastoise).
entrena(misty,venusaur).
entrena(misty,arceus).

% Parte 1. Pokédex 

% 1) Saber si un pokémon es de tipo múltiple, esto ocurre cuando tiene más de un tipo.

esMultiple(Pokemon):-
    pokemon(Pokemon,Tipo),
    pokemon(Pokemon,OtroTipo),
    Tipo \= OtroTipo.

% 2) Saber si un pokemon es legendario, lo cual ocurre si es de tipo múltiple y ningún entrenador lo tiene.
esLegendario(Pokemon):-
    pokemon(Pokemon,_),
    esMultiple(Pokemon),
    nadieLoTiene(Pokemon).

nadieLoTiene(Pokemon):-
    pokemon(Pokemon,_),
    forall( entrena(Entrenadores,_), 
    not(entrena(Entrenadores,Pokemon))).
    /*esLegendario(Pokemon):-
    esTipoMultiple(Pokemon),
    not(tiene(_, Pokemon)).*/

% 3)  Saber si un pokemon es misterioso, lo cual ocurre si es el único en su tipo o ningún entrenador lo tiene. 
esMisterioso(Pokemon):-
    pokemon(Pokemon,Tipo),
    not((pokemon(OtroPokemon,Tipo), Pokemon \= OtroPokemon)).

% Parte 2. Movimientos

% El daño de ataque de un movimiento
movimiento(mordedura,fisico(95)).
movimiento(impactrueno,especial(40,electrico)).
movimiento(garraDragon,especial(100,dragon)).
movimiento(proteccion,defensivo(10)).
movimiento(placaje,fisico(50)).
movimiento(alivio,defensivo(100)).

movimiento(impactruenoo,especial(40,fuego)).


puedeUsar(pikachu,mordedura).
puedeUsar(pikachu,impactrueno).
puedeUsar(charizard,gorraDragon).
puedeUsar(charizard,mordedura).
puedeUsar(blastoise,proteccion).
puedeUsar(blastoise,placaje).
puedeUsar(arceus,impactrueno).
puedeUsar(arceus,garraDragon).
puedeUsar(arceus,proteccion).
puedeUsar(arceus,placaje).
puedeUsar(arceus,alivio).

ataque(Movimiento,Danio):-
    movimiento(Movimiento, fisico(Danio)).

ataque(Movimiento,Danio):-
    movimiento(Movimiento, defensivo(_)),
    Danio is 0.

ataque(Movimiento,Danio):-
    movimiento(Movimiento, especial(Potencia,Tipo)),
    esBasico(Tipo),
    multiplicador(Potencia,(1.5),Danio).

ataque(Movimiento,Danio):-
    movimiento(Movimiento, especial(Potencia,dragon)),
    multiplicador(Potencia,3,Danio).

multiplicador(Potencia,Numero,Danio):-
    Danio is Potencia * Numero.

ataque(Movimiento,Danio):-
    movimiento(Movimiento, especial(Danio,Tipo)).
%    not(esBasico(Tipo)),
%    Tipo \= dragon.

esBasico(fuego).
esBasico(agua).
esBasico(planta).
esBasico(normal).

% La capacidad ofensiva de un pokemon , la cual está dada por la sumatoria de los daños de ataque de los movimientos que puede usar.

capacidadOfensiva(Pokemon,Capacidad):-
    pokemon(Pokemon,_),
    findall(Danios, (puedeUsar(Pokemon,Movimiento),ataque(Movimiento,Danios)),DaniosDelPokemon),
    sum_list(DaniosDelPokemon, Capacidad).
        

% Si un entrenador es picante, lo cual ocurre si todos sus pokemons tienen una capacidad ofensiva total superior a 200 o son misteriosos.
esPicante(Entrenador):-
    entrena(Entrenador,_),
    forall(entrena(Entrenador,Pokemons),
    capacidadOfensivaMayorA(Pokemons, 200)).

capacidadOfensivaMayorA(Pokemon,Numero):-
    pokemon(Pokemon,_),
    capacidadOfensiva(Pokemon,Capacidad),
    Capacidad > Numero.

esPicante(Entrenador):-
    entrena(Entrenador,_),
    forall(entrena(Entrenador,Pokemons),
    esMisterioso(Pokemons)).