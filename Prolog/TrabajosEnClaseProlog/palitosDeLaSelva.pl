

/*animal(Nombre,Clase, Medio)*/
animal(ballena,mamifero,acuatico).
animal(tiburon,pez,acuatico).
animal(lemur,mamifero,terrestre).
animal(golondrina,ave,aereo).
animal(tarantula,insecto,terrestre).
animal(lechuza,ave,aereo).
animal(orangutan,mamifero,terrestre).
animal(tucan,ave,aereo).
animal(puma,mamifero,terrestre).
animal(abeja,insecto,aereo).
animal(leon,mamifero,terrestre).
animal(lagartija,reptil,terrestre).

/* tiene(Quien, Que, Cuantos)*/
tiene(nico, ballena, 1).
tiene(nico, lemur, 2).
tiene(maiu, lemur, 1).
tiene(maiu, tarantula, 1).
tiene(juanDS, golondrina, 1).
tiene(juanDS, lechuza, 1).
tiene(juanR, tiburon, 2).
tiene(nico, golondrina, 1).
tiene(juanDS, puma, 1).
tiene(maiu, tucan, 1).
tiene(juanR, orangutan,1).
tiene(maiu,leon,2).
tiene(juanDS,lagartija,1).
tiene(feche,tiburon,1).

% animalDificil/1: que se cumple para los animales que nadie tiene o que como mucho hay una sola persona que tiene sólo uno.
animalDificil(Animal):-
    animal(Animal,_,_),
    not(tiene(_,Animal,_)).

animalDificil(Animal):-
    tiene(Persona,Animal,1),
    not( (tiene(OtraPersona,Animal,_),Persona \= OtraPersona) ).

leGusta(nico,Animal):-
    animal(Animal,_,terrestre),
    Animal \= lemur.

leGusta(maiu,Animal):-
    animal(Animal,Clase,_),
    Clase \= insecto.
leGusta(maiu,abeja).

leGusta(juanDS,Animal):-
    animal(Animal,_,acuatico).
leGusta(juanDS,Animal):-
    animal(Animal,ave,_).

leGusta(juanR,Animal):-
    tiene(juanR,Animal,_).

leGusta(feche,lechuza).

% 2) qué animales tieneParaIntercambiar/2 una persona siendo estos aquellos que tenga la persona y que no le guste o que tenga más de uno. Además, juanR puede intercambiar los que tiene juanDS porque no tiene códigos.
tieneParaIntercambiar(juanR,Animal):-
    tiene(juanDS,Animal,_).
tieneParaIntercambiar(Persona,Animal):-
    tieneMasDeUno(Persona,Animal).
tieneParaIntercambiar(Persona,Animal):-
    tieneYNoLeGusta(Persona,Animal).

tieneMasDeUno(Persona,Animal):-
    tiene(Persona,Animal,Cantidad),
    Cantidad > 1.

tieneYNoLeGusta(Persona,Animal):-
    tiene(Persona,Animal,_),
    not(leGusta(Persona,Animal)).

% 3) Ahora queremos saber si tieneParaOfrecerle/2 una persona a otra: esto se cumple si la primera persona tiene para intercambiar animales que le gustan a la segunda y que la segunda no tiene.
tieneParaOfrecerle(Persona,OtraPersona):-
    tieneParaIntercambiar(Persona,Animal),
    leGusta(OtraPersona,Animal),
    Persona \= OtraPersona,
    not(tiene(OtraPersona,Animal,_)).

% 4)  quienes puedenNegociar/2: sabiendo que pueden negociar 2 personas si ambas tienen para ofrecerse mutuamente.
puedenNegociar(Persona,OtraPersona):-
    tieneParaOfrecerle(Persona,OtraPersona),
    tieneParaOfrecerle(OtraPersona,Persona).

% 5) estaTriste/1: que nos dice si una persona sólo tiene animales que no le gustan.
estaTriste(Persona):-
    tiene(Persona,_,_),
    forall(tiene(Persona,Animales,_), 
    not(leGusta(Persona,Animales)) ).
estaTriste(Persona):-
    tiene(Persona,_,_),
    not( (tiene(Persona,Animal,_),
    leGusta(Persona,Animal)) ).
    
% 6) estaFeliz/1: que nos dice si a una persona le gustan todos los animales que tiene.
estaFeliz(Persona):-
    tiene(Persona,_,_),
    forall(tiene(Persona,Animales,_), 
    leGusta(Persona,Animales) ).
estaFeliz(Persona):-
    tiene(Persona,_,_),
    not( (tiene(Persona,Animal,_),
        not(leGusta(Persona,Animal))) ).

% 7) tieneTodosDe/2:que relaciona una persona con un medio o clase si todos sus animales son de ese medio o clase.
tieneTodosDe(Persona,Medio):-
    animal(_,_,Medio),
    tiene(Persona,_,_),
    forall(tiene(Persona,Animales,_),
    animal(Animales,_,Medio)). 
tieneTodosDe(Persona,Clase):-
    animal(_,Clase,_),
    tiene(Persona,_,_),
    forall(tiene(Persona,Animales,_),
    animal(Animales,Clase,_)).
/*animal(Nombre,Clase, Medio)*/

% 8) completoLaColeccion/1: que se cumple si la persona tiene todos los animales
completoLaColeccion(Persona):-
    tiene(Persona,_,_),
    forall(animal(Animales,_,_),
    tiene(Persona,Animales,_)).

% 9) manejaElMercado/1: una persona maneja el mercado si tiene para ofrecerles a todos los demás.
manejaElMercado(Persona):-
    tiene(Persona,_,_),
    forall( (tiene(Personas,_,_), Persona \= Personas),
    tieneParaOfrecerle(Persona, Personas) ).

% 10) delQueMasTiene/2: relaciona a una persona con un animal si tiene más de ese que de los otros.
delQueMasTiene(Persona,Animal):-
    tiene(Persona,Animal,CantidadMayor),
    forall( (tiene(Persona,Animales,Cantidades),  Animal \= Animales),
CantidadMayor > Cantidades).

% delQueMasTiene(Persona, Animal):-
%     tiene(Persona, Animal, Cantidad),
%     not(
%         (tiene(Persona, OtroAnimal, CantidadDeOtro),
%         Animal \= OtroAnimal,
%         Cantidad =< CantidadDeOtro)
%     ).
    