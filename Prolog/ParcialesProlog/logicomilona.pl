

% receta(Plato, Duración, Ingredientes)
receta(empanadaDeCarneFrita, 20, [harina, carne, cebolla, picante, aceite]).
receta(empanadaDeCarneAlHorno, 20, [harina, carne, cebolla, picante]).
receta(lomoALaWellington, 125, [lomo, hojaldre, huevo, mostaza]).
receta(pastaTrufada, 40, [spaghetti, crema, trufa]).
receta(souffleDeQueso, 35, [harina, manteca, leche, queso]).
receta(tiramisu, 30, [vainillas, cafe, mascarpone]).
receta(rabas, 20, [calamar, harina, sal]).
receta(parrilladaDelMar, 40, [salmon, langostinos, mejillones]).
receta(sushi, 30, [arroz, salmon, sesamo, algaNori]).
receta(hamburguesa, 15, [carne, pan, cheddar, huevo, panceta, trufa]).
receta(padThai, 40, [fideos, langostinos, vegetales]).

% elabora(Chef, Plato)
elabora(guille, empanadaDeCarneFrita).
elabora(guille, empanadaDeCarneAlHorno).
elabora(vale, rabas).
elabora(vale, tiramisu).
elabora(vale, parrilladaDelMar).
elabora(ale, hamburguesa).
elabora(lu, sushi).
elabora(mar, padThai).

% cocinaEn(Restaurante, Chef)
cocinaEn(pinpun, guille).
cocinaEn(laPececita, vale).
cocinaEn(laParolacha, vale).
cocinaEn(sushiRock, lu).
cocinaEn(olakease, lu).
cocinaEn(guendis, ale).
cocinaEn(cantin, mar).

% tieneEstilo(Restaurante, Estilo)
tieneEstilo(pinpun, bodegon(parqueChas, 6000)).
tieneEstilo(laPececita, bodegon(palermo, 20000)).
tieneEstilo(laParolacha, italiano(15)).
tieneEstilo(sushiRock, oriental(japon)).
tieneEstilo(olakease, oriental(japon)).
tieneEstilo(cantin, oriental(tailandia)).
tieneEstilo(cajaTaco, mexicano([habanero, rocoto])).
tieneEstilo(guendis, comidaRapida(5)).

% Los posibles estilos tienen la siguiente forma:

% italiano(CantidadDePastas)
% oriental(País)
% bodegon(Barrio, PrecioPromedio)
% mexicano(VariedadDeAjies)
% comidaRapida(cantidadDeCombos)

% 1) 😎esCrack/1: un o una chef es crack si trabaja en por lo menos dos restaurantes o cocina pad thai.

esCrack(Chef):-
    elabora(Chef, padThai).

esCrack(Chef):-
    cocinaEn(Resto1,Chef),
    cocinaEn(Resto2,Chef),
    Resto1 \= Resto2.

% 2) 🍙esOtaku/1: un o una chef es otaku cuando solo trabaja en restaurantes de comida japonesa. (Y le tiene que gustar Naruto, pero eso no lo vamos a modelar).

esOtaku(Chef):-
    cocinaEn(_,Chef),
    forall(cocinaEn(Restos, Chef), 
    tieneEstilo(Restos,oriental(_))).

% 3) 🔥esTop/1: un plato es top si sólo lo elaboran chefs cracks.

esTop1(Plato):-
    elabora(_,Plato),
    forall( elabora(Chefs, Plato), esCrack(Chefs) ).

% 4) 🤯esDificil/1: un plato es difícil cuando tiene una duración de más de dos horas o tiene trufa como ingrediente o es un soufflé de queso.

esDificil(Plato):-
    receta(Plato,Duracion,_),
    Duracion > 2.

esDificil(Plato):-
    receta(Plato,_,Ingredientes),
    member(trufa, Ingredientes).

esDificil(souffleDeQueso).

% 5) ⭐seMereceLaMichelin/1: un restaurante se merece la estrella Michelin cuando tiene un o una chef crack y su estilo de cocina es michelinero. Esto sucede cuando es un restaurante

seMereceLaMichelin(Resto):-
    cocinaEn(Resto,Chef),
    esCrack(Chef),
    estiloMichelinero(Resto).

estiloMichelinero(Resto):-
    tieneEstilo(Resto, oriental(tailandia)).

estiloMichelinero(Resto):-
    tieneEstilo(Resto, bodegon(palermo,_)).

estiloMichelinero(Resto):-
    tieneEstilo(Resto, italiano(CantidadDePastas)),
    CantidadDePastas > 5.

estiloMichelinero(Resto):-
    tieneEstilo(Resto, mexicano(Ajies)),
    member(habanero, Ajies),
    member(rocoto, Ajies).
    
% 6) 🗒️tieneMayorRepertorio/2: según dos restaurantes, se cumple cuando el primero tiene un o una chef que elabora más platos que el o la chef del segundo.

tieneMayorRepertorio(Resto,OtroResto):-
    cocinaEn(Resto,Chef),
    cocinaEn(OtroResto, OtroChef),
    cantidadDePlatosElaborados(Chef,CantPlatosChef),
    cantidadDePlatosElaborados(OtroChef,CantPlatosOtroChef),
    CantPlatosChef > CantPlatosOtroChef.
    
cantidadDePlatosElaborados(Chef,Cantidad):-
    findall(PlatosElaborados, elabora(Chef,PlatosElaborados), PlatosChef),
    length(PlatosChef, Cantidad).

% 7) 👍calificacionGastronomica/2: la calificación de un restaurante es 5 veces la cantidad de platos que elabora el o la chef de este restaurante. 

calificacionGastronomica(Resto,Calificacion):-
    cocinaEn(Resto,Chef),
    cantidadDePlatosElaborados(Chef, Cantidad),
    Calificacion is 5 * Cantidad.
    


    
    