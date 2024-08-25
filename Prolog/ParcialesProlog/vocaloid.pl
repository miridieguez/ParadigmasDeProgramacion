% Este parcial esta bueno para ver functores abajo y tambien hay algunos errores que esta bueno entenderlos

% De cada vocaloid (o cantante) se conoce el nombre y además la canción que sabe cantar. 
% De cada canción se conoce el nombre y la cantidad de minutos de duración.

% a) Generar la base de conocimientos inicial

persona(megurineLuka).
persona(hatsuneMiku).
persona(seeU).
persona(gumi).
persona(kaito).

vocaloid(megurineLuka,nightFever,4).
vocaloid(megurineLuka,foreverYoung,5).

vocaloid(hatsuneMiku,tellYourWorld,4).

vocaloid(gumi,foreverYoung,4).
vocaloid(gumi,tellYourWorld,5).

vocaloid(seeU,novemberRain,6).
vocaloid(seeU,nightFever,5).


% Definir los siguientes predicados que sean totalmente inversibles, a menos que se indique lo contrario.

/* 1) Para comenzar el concierto, es preferible introducir primero a los cantantes más novedosos, 
por lo que necesitamos un predicado para saber si un vocaloid es novedoso cuando saben al menos 2 canciones 
y el tiempo total que duran todas las canciones debería ser menor a 15.
*/

esNovedoso(Vocaloid):-
	vocaloid(Vocaloid,_,_),
	conoceMasDeUnaCancion(Vocaloid),
	duracionDeCancionces(Vocaloid,Duracion),
	Duracion < 15.

conoceMasDeUnaCancion(Vocaloid):-
	vocaloid(Vocaloid,Cancion,_),
	vocaloid(Vocaloid,OtraCancion,_),
	Cancion \= OtraCancion.

duracionDeCancionces(Vocaloid,DuracionTotal):-
	vocaloid(Vocaloid,_,_),
	findall(Duraciones,vocaloid(Vocaloid,_,Duraciones),DuracionesDeLasCanciones),
	sum_list(DuracionesDeLasCanciones, DuracionTotal).
	
/* 2) Hay algunos vocaloids que simplemente no quieren cantar canciones largas porque no les gusta, 
es por eso que se pide saber si un cantante es acelerado, condición que se da cuando todas sus canciones duran 4 minutos o menos.
Resolver sin usar forall/2.
*/

esAcelerado(Vocaloid):-
	%para toda cancion que canta, duran 4 o menos minutos -> la negacion es no existe alguna cancion que dure mas de cuatro minutos
	vocaloid(Vocaloid,_,_), 
	not( tieneCancionQueDureMasDe(4,Vocaloid) ).

tieneCancionQueDureMasDe(Minutos,Vocaloid):-
	vocaloid(Vocaloid,_,Duracion),
	Duracion > Minutos.

% version con forall
%esAcelerado(Vocaloid):-
%	vocaloid(Vocaloid,_,_),
%	forall(vocaloid(Vocaloid,_,Duraciones), Duraciones =< 4 ).


% Modelar los conciertos y agregar en la base de conocimiento todo lo necesario.

tipo(gigante(cantidadMinimaDeCanciones, duracionTotalMinimaDeLasCanciones)).
tipo(mediano(duracionTotalMaximaDeLasCanciones)).
tipo(pequenio(duracionMinimaDeAlgunaCancion)).

% concierto(Nombre,Pais,Fama,Tipo).
concierto(mikuExpo,usa,2000,tipo(gigante(2,6))).
concierto(magicalMirai,japon,3000,tipo(gigante(3,10))).
concierto(vocalektVisions,usa,1000,tipo(mediano(9))).
concierto(mikuFest,argentina,100,tipo(pequenio(4))).

/*Se requiere saber si un vocaloid puede participar en un concierto, esto se da cuando cumple los requisitos del tipo de concierto. 
También sabemos que Hatsune Miku puede participar en cualquier concierto.
*/

puedeParticiparEnConcierto(hatsuneMiku,_).

/*
Duda cual es la mejor forma
puedeParticipar(hatsuneMiku,Concierto):-
	concierto(Concierto, _, _, _).
*/

puedeParticiparEnConcierto(Vocaloid,Concierto):-
	vocaloid(Vocaloid,_,_),
	concierto(Concierto,_,_,tipo(Tipo)),
	cumpleConLosRequisitos(Vocaloid,Tipo).

cumpleConLosRequisitos(Vocaloid,gigante(CantidadMinimaDeCanciones, DuracionTotalMinimaDeLasCanciones)):-
	vocaloid(Vocaloid,_,_),
	calcularCantidadDeCanciones(Vocaloid,CantidadDeCanciones),
	CantidadDeCanciones >= CantidadMinimaDeCanciones,
	duracionDeCancionces(Vocaloid,Duracion),
	Duracion > DuracionTotalMinimaDeLasCanciones.
	
calcularCantidadDeCanciones(Vocaloid,CantidadDeCanciones):-
	vocaloid(Vocaloid,_,_),
	findall(Canciones,vocaloid(Vocaloid,Canciones,_),ListaDeCanciones),
	length(ListaDeCanciones, CantidadDeCanciones).

cumpleConLosRequisitos(Vocaloid,mediano(DuracionTotalMaximaDeLasCanciones)):-
	vocaloid(Vocaloid,_,_),
	duracionDeCancionces(Vocaloid,Duracion),
	Duracion < DuracionTotalMaximaDeLasCanciones.

cumpleConLosRequisitos(Vocaloid,pequenio(duracionMinimaDeAlgunaCancion)):-
	vocaloid(Vocaloid,_,_),
	tieneCancionQueDureMasDe(duracionMinimaDeAlgunaCancion,Vocaloid).

% 3) Conocer el vocaloid más famoso, es decir con mayor nivel de fama. El nivel de fama de un vocaloid se calcula como la fama total que le dan los 
% conciertos en los cuales puede participar multiplicado por la cantidad de canciones que sabe cantar

vocaloidMasFamoso(Vocaloid):-
	vocaloid(Vocaloid,_,_),
	nivelDeFama(Vocaloid,MayorNivel),
	forall(( nivelDeFama(Vocaloids,Niveles), Vocaloids \= Vocaloid), MayorNivel >= Niveles).

nivelDeFama(Vocaloid,Nivel):-
	famaTotal(Vocaloid,FamaTotal),
	calcularCantidadDeCanciones(Vocaloid,CantidadDeCanciones),
	Nivel is FamaTotal * CantidadDeCanciones.

famaTotal(Vocaloid,FamaTotal):-
	vocaloid(Vocaloid,_,_),
	listaDeFamas(Vocaloid, ListaDeFamas),
	sum_list(ListaDeFamas,FamaTotal).

/* OJO, esto no funciona!!! En el findall no se puede poner tan especifico, hay que crear mas relaciones.
listaDeFamas(Vocaloid, ListaDeFamas):-
	vocaloid(Vocaloid,_,_),
	findall(Famas, puedeParticiparEnConcierto(Vocaloid,concierto(_,_,Famas,_)),ListaDeFamas).*/

listaDeFamas(Vocaloid, ListaDeFamas):-
	vocaloid(Vocaloid,_,_),
	findall(Famas, fama(Vocaloid,Famas),ListaDeFamas).

fama(Vocaloid,Fama):-
	vocaloid(Vocaloid,_,_),
	puedeParticiparEnConcierto(Vocaloid,Concierto),
	concierto(Concierto,_,Fama,_).

/* Aca hay otra opcion con mas relaciones
fama(Vocaloid,Fama):-
	vocaloid(Vocaloid,_,_),
	puedeParticiparEnConcierto(Vocaloid,Concierto),
	miniFama(Concierto,Fama).

miniFama(Concierto,Fama):-
	concierto(Concierto,_,Fama,_).
*/

/* 4)
Queremos verificar si un vocaloid es el único que participa de un concierto, esto se cumple si ninguno de sus conocidos 
ya sea directo o indirectos (en cualquiera de los niveles) participa en el mismo concierto.*/


conoceDirectamente(megurineLuka,hatsuneMiku).
conoceDirectamente(megurineLuka,gumi).
conoceDirectamente(gumi,seeU).
conoceDirectamente(seeU,kaito).

conoce(Vocaloid,OtroVocaloid):-
	conoceDirectamente(Vocaloid,OtroVocaloid).

conoce(Vocaloid,OtroVocaloid):-
	vocaloid(Vocaloid,_,_),
	vocaloid(OtroVocaloid,_,_),
	vocaloid(VocaloidDirecto,_,_),
	conoceDirectamente(Vocaloid,VocaloidDirecto),
	conoce(VocaloidDirecto,OtroVocaloid).

esElUnicoParticipanteEnElConcierto(Vocaloid,Concierto):-
	puedeParticiparEnConcierto(Vocaloid,Concierto),
	forall(conoce(Vocaloid,Conocidos), not(puedeParticiparEnConcierto(Conocidos,Concierto))).
	
/* OTRA OPCION
not((conoce(Vocaloid, OtroVocaloid), 
puedeParticiparEnConcierto(OtroVocaloid, Concierto))).*/