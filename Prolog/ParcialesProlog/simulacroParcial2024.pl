% Modelado inicial

%personaje(Nombre, Clase, Oro)
personaje(rin,mago,20).
personaje(atalanta,mago,5).
personaje(kelsier,luchador,50).
personaje(thorfinn,barbaro,15).

%es(Nombre, Caracteristicas)
es(rin,responsable).
es(rin,pacifica).
es(atalanta,responsable).
es(atalanta,fuerte).
es(kelsier,noble).
es(thorfinn,agresivo).
es(thorfinn,fuerte).

%sabe(Nombre, Poder, Potencia)
sabe(rin,fuego,20).
sabe(rin,frio,30).
sabe(atalanta,fuego,30).

tiene(kelsier,permisoReal).

% 1. Queremos saber 
% a) si dos aventureros son camaradas, que se cumple si los dos son de la misma clase
sonCamaradas(Aventurero,OtroAventurero):-
    personaje(Aventurero,Clase,_),
    personaje(OtroAventurero,Clase,_),
    Aventurero \= OtroAventurero.

% b) si una característica es popular entre una clase, lo cual se cumple si todos los miembros de esa clase la poseen
esPopular(Caracteristica,Clase):-
    es(_,Caracteristica),
    personaje(_,Clase,_),
    forall(personaje(Personajes, Clase, _), 
    es(Personajes, Caracteristica)).
    

% c) si un aventurero puede disponer de un permiso real, esto se cumple si ya lo tiene o si tiene los fondos para comprarlo, 50 de oro.
puedeDisponerDelPermisoReal(Personaje):-
    personaje(Personaje,_,OroDisponible),
    valorPermisoReal(Valor),
    OroDisponible >= Valor.
puedeDisponerDelPermisoReal(Personaje):-
    tiene(Personaje,permisoReal).

valorPermisoReal(50).

% 2. Misiones

% a) Queremos poder contestar si un aventurero puede realizar una misión, lo cual es cierto si cumple sus requisitos.

mision(ayudarACruzarLaCalle,barrio).
mision(ayudarACortarLenia,barrio).
mision(escoltaReal(diplomatico),aspirante).
mision(escoltaReal(princesa),heroica).
mision(pesadillaDeLaCueva,heroica).
mision(rosasHeladas(montes),barrio).
mision(rosasHeladas(altasMontanias),aspirante).

puedeRealizarLaMision(_, ayudarACruzarLaCalle).

puedeRealizarLaMision(Aventurero, ayudarACortarLenia):-
    es(Aventurero, fuerte).

puedeRealizarLaMision(Aventurero, escoltaReal(diplomático)):-
    puedeDisponerDelPermisoReal(Aventurero).
puedeRealizarLaMision(Aventurero, escoltaReal(princesa)):-
    tiene(Aventurero,permisoReal),
    es(Aventurero,noble).

puedeRealizarLaMision(Aventurero, pesadillaDeLaCueva):-
    personaje(Aventurero,barbaro,_),
    es(Aventurero,agresivo).
puedeRealizarLaMision(Aventurero, pesadillaDeLaCueva):-
    sabeHechizoDePotenciaMayorA(Aventurero, fuego, 30).
    
puedeRealizarLaMision(Aventurero, rosasHeladas(_)):-
    personaje(Aventurero,_,Fondos),
    fondosNecesariosParaPociones(FondosNecesarios),
    Fondos >= FondosNecesarios,
    sabeHechizoDePotenciaMayorA(Aventurero,frio,20).

fondosNecesariosParaPociones(20).

sabeHechizoDePotenciaMayorA(Aventurero, Tipo, PotenciaRequerida):-
    personaje(Aventurero,_,_),
    sabe(Aventurero,Tipo,Potencia),
    Potencia >= PotenciaRequerida.


%  b) Queremos saber si una misión es fácil, que se cumple cuando todos los aventureros pueden realizarla.

esFacil(Mision):-
    mision(Mision,_),
    forall(personaje(Personajes,_,_),
    puedeRealizarLaMision(Personajes, Mision)).

% Resultados de las misiones
% Queremos poder contestar qué misiones intentó hacer cada aventurero:

intento(kelsier,pesadillaDeLaCueva).
intento(kelsier,ayudarACortarLenia).
intento(rin,rosasHeladas(altasMontanias)).
intento(rin,escoltaReal(princesa)).
intento(thorfinn,pesadillaDeLaCueva).
intento(atalanta,ayudarACruzarLaCalle).
intento(atalanta,ayudarACortarLenia).

%Queremos conocer los resultados de cada misión intentada de cada aventurero:

resultado(Aventurero,Mision,exitoso):-
    intento(Aventurero,Mision),
    puedeRealizarLaMision(Aventurero,Mision).
resultado(Aventurero,Mision,fallido):-
    personaje(Aventurero,_,_),
    intento(Aventurero,Mision),
    esDeAspiranteODeBarrio(Mision),
    not(puedeRealizarLaMision(Aventurero,Mision)).
resultado(Aventurero,Mision,fatal):-
    personaje(Aventurero,_,_),
    mision(Mision,heroica),
    not(puedeRealizarLaMision(Aventurero,Mision)).

esDeAspiranteODeBarrio(Mision):-
    mision(Mision,barrio).
esDeAspiranteODeBarrio(Mision):-
    mision(Mision,aspirante).

% Queremos saber si un aventurero es afortunado, lo cual se cumple si cumplió exitosamente todas las misiones que intentó.

esAfortunado(Aventurero):-
    personaje(Aventurero,_,_),
    forall(intento(Aventurero,Misiones),
    resultado(Aventurero, Misiones, exitoso)).

%  Recompensas
%Saber cuánta recompensa en oro se le debe dar a cada aventurero, teniendo en cuenta que obtiene una recompensa en oro por cada misión exitosa. 
%Además, tener en cuenta que si murió en alguna misión (es decir, obtuvo un resultado fatal), no obtiene nada de recompensa. 
%La recompensa de las misiones de barrio es 2 de oro, de las misiones de aspirante es 15, y de las misiones heroicas es 50.

recompensa(Aventurero,0):-
    murio(Aventurero).
recompensa(Aventurero,RecompensaTotal):-
    personaje(Aventurero,_,_),
    not(murio(Aventurero)),
    misionesExitosasDeTipo(barrio, Aventurero,MisionesExitosasBarriales),
    valorporMisionBarrial(ValorBarrial),
    misionesExitosasDeTipo(heroica, Aventurero,MisionesExitosasHeroicas),
    valorporMisionHeroica(ValorHeroico),
    misionesExitosasDeTipo(aspirante, Aventurero,MisionesExitosasAspirantes),
    valorporMisionAspirante(ValorAspirante),
    RecompensaTotal is MisionesExitosasBarriales * ValorBarrial + MisionesExitosasAspirantes * ValorAspirante + MisionesExitosasHeroicas * ValorHeroico.

valorporMisionBarrial(2).
valorporMisionHeroica(50).
valorporMisionAspirante(15).

murio(Aspirante):-
    intento(Aspirante,Mision),
    resultado(Aspirante,Mision,fatal).

misionesExitosasDeTipo(Tipo,Aventurero,CantidadDeMisionesExitosasDeTipo):-
    personaje(Aventurero,_,_),
    findall(Misiones, (mision(Misiones,Tipo),intento(Aventurero, Misiones),resultado(Aventurero, Misiones, exitoso)), MisionesExitosas),
    length(MisionesExitosas, CantidadDeMisionesExitosasDeTipo).
    
%Quién es el más recompensado, es decir, quién es el que más oro debe recibir en total como recompensa por sus misiones.

masRecompensado(Aventurero):-
    recompensa(Aventurero,RecompensaMayor),
    forall( (personaje(Aventureros,_,_), Aventurero\= Aventureros, recompensa(Aventureros,Recompensa)),
    RecompensaMayor > Recompensa).