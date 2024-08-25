

% rata(nombre, lugarDeTrabajo)
rata(remy, gusteaus).
rata(emile, chezMilleBar).
rata(django, pizzeriaJeSuis).

%humano(nombre, platoQueCocina, experiencia).
humano(linguini, ratatuille, 3).
humano(linguini, sopa, 5).
humano(colette, salmonAsado, 9).
humano(horst, ensaladaRusa, 8).


%trebajaEn(nombre , Lugar)
trabajaEn(colette, gusteaus).
trabajaEn(linguini, gusteaus).
trabajaEn(horst, gusteaus).
trabajaEn(skinner, gusteaus).
trabajaEn(amelie, cafeDes2Moulins).

% 1. Saber si un plato está en el menú de un restaurante, que es cuando alguno de los empleados lo sabe cocinar.

estaEnElMenu(Plato, Restaurant):-
    humano(Cocinero, Plato, _),
    trabajaEn(Cocinero, Restaurant).

% 2. Saber quién cocina bien un determinado plato

tutor(linguini,Tutor):-
    rata(Tutor,Vivienda),
    trabajaEn(linguini,Vivienda).

tutor(skinner,amelie).

cocinaBien(remy, Plato):-
    humano(_,Plato,_).

cocinaBien(Cocinero, Plato):-
    humano(Cocinero, Plato, Experiencia),
    Experiencia > 7.

cocinaBien(Cocinero, Plato):-
    tutor(Cocinero, Tutor),
    cocinaBien(Tutor, Plato).

% 3. Saber si alguien es chef de un restó.
experienciaDeLosPlatosQueSabeCocinar(Chef, ExperienciaTotal):-
    findall(Experiencias, humano(Chef,_,Experiencias) , ListaDeExperiencias),
    sum_list(ListaDeExperiencias, ExperienciaTotal).

esChefDelResto(Chef,Resto):-
    trabajaEn(Chef, Resto),
    forall(estaEnElMenu(Platos,Resto), cocinaBien(Chef, Platos)).
    
esChefDelResto(Chef,Resto):-
    trabajaEn(Chef,Resto),
    experienciaDeLosPlatosQueSabeCocinar(Chef, Experiencia),
    Experiencia >= 20.

% 4. Deducir cuál es la persona encargada de cocinar un plato en un restaurante, que es quien más experiencia tiene preparándolo en ese lugar.
encargado(Plato,Resto,Encargado):-
    humano(Encargado, Plato ,Experiencia),
    trabajaEn(Encargado,Resto),
    forall( (humano(Chefs, Plato, Experiencias), trabajaEn(Chefs, Resto), Encargado \= Chefs),
    Experiencia > Experiencias ).

% De toda entrada se sabe la lista de ingredientes que la componen
% de cada plato principal se sabe su acompañamiento y el tiempo
% de cada postre se sabe las calorías que aportan.

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 20)).
plato(frutillasConCrema, postre(265)).

% 5. Si un plato es saludable (si tiene menos de 75 calorías).
esSaludable(Plato):-
    caloriasDelPlato(Plato,Calorias),
    Calorias < 75.

caloriasDelPlato(Plato,Calorias):-
    plato(Plato,entrada(ListaDeIngredientes)),
    length(ListaDeIngredientes, CantidadDeIngredientes),
    Calorias is CantidadDeIngredientes * 15.

caloriasDelPlato(Plato, Calorias):-
    plato(Plato,principal(Acompaniamiento, Minutos)),
    caloriasDelAcompaniamiento(Acompaniamiento, CaloriasAcompaniamiento),
    Calorias is CaloriasAcompaniamiento + Minutos * 5.

caloriasDelPlato(Plato, Calorias):-
    plato(Plato, postre(Calorias)).

caloriasDelAcompaniamiento(papasFritas, 50).
caloriasDelAcompaniamiento(pure, 20).
caloriasDelAcompaniamiento(ensalada, 0).

% 6. Criticos

hizoReseniaPositiva(Critico, Resto):-
    trabajaEn(_,Resto),
    forall(rata(_,Vivienda), Vivienda \= Resto),
    cumpleLosRequisitosDelCritico(Critico, Resto).

cumpleLosRequisitosDelCritico(antonEgo, Resto):-
    forall( trabajaEn(Empleados, Resto),cocinaBien(Empleados, ratatuille)).

cumpleLosRequisitosDelCritico(cormillot, Resto):-
    forall( (humano(Empleados,Platos,_), trabajaEn(Empleados,Resto)), esSaludable(Platos)).

cumpleLosRequisitosDelCritico(martiniano, Resto):-
    chefsDelResto(Resto,Chefs),
    length(Chefs,CantidadDeChefs),
    CantidadDeChefs = 1.

chefsDelResto(Resto, ListaDeChefs):-
    findall(Chefs, esChefDelResto(Chefs, Resto), ListaDeChefs).

/*otra forma:
cumpleCriterio(Resto, martiniano):-
    trabaja(Cocinero, Resto), 
    not((trabaja(Cocinero2, Resto), 
    Cocinero \= Cocinero2)).
*/

