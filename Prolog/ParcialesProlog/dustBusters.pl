

herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

% herramientasRequeridas(ordenarCuarto, [[escoba, aspiradora(100)], trapeador, plumero]).

% 1) 

% cazaFantasma(nombre).
cazaFantasma(egon).
cazaFantasma(peter).
cazaFantasma(ray).
cazaFantasma(winston).
cazaFantasma(walter).
cazaFantasma(louis).
cazaFantasma(dana).




% tiene(cazafantasma,herramienta).

tiene(egon,aspiradora(200)).
tiene(egon,trapeador).

tiene(peter,trapeador).

tiene(winston,varitaDeNeutrones).

% 2) Definir un predicado que determine si un integrante satisface la necesidad de una herramienta requerida. 

satisfaceLaNecesidadDeHerramienta(CazaFantasma,Herramienta):-
    tiene(CazaFantasma,Herramienta).

satisfaceLaNecesidadDeHerramienta(CazaFantasma, aspiradora(PotenciaRequerida)):-
    tiene(CazaFantasma,aspiradora(Potencia)),
    between(0, Potencia, PotenciaRequerida). %inversible
	%Potencia >= PotenciaRequerida. -- No inversible hacia PotenciaRequerida

/*Esto va a machear con la lista dentro de la lista de herramientas (si encuentra)
satisfaceNecesidad(Persona, ListaRemplazables):-
	member(Herramienta, ListaRemplazables),
	satisfaceNecesidad(Persona, Herramienta).*/

% 3) Queremos saber si una persona puede realizar una tarea, que dependerá de las herramientas que tenga. 

puedeRealizarTarea(CazaFantasma,Tarea):-
    herramientasRequeridas(Tarea,_),
    tiene(CazaFantasma, varitaDeNeutrones).

puedeRealizarTarea(CazaFantasma,Tarea):-
    cazaFantasma(CazaFantasma),
    herramientasRequeridas(Tarea, ListaDeHerramientasRequeridas),        
    forall( member(Herramientas, ListaDeHerramientasRequeridas), 
        satisfaceLaNecesidadDeHerramienta(CazaFantasma, Herramientas) ).

/* Mejor abstraer:
puedeHacerTarea(CazaFantasma, Tarea):-
    cazaFantasma(CazaFantasma),
	requiereHerramienta(Tarea, _),
	forall(requiereHerramienta(Tarea, Herramienta),
		satisfaceNecesidad(CazaFantasma, Herramienta)).

requiereHerramienta(Tarea, Herramienta):-
	herramientasRequeridas(Tarea, ListaDeHerramientas),
	member(Herramienta, ListaDeHerramientas*/


% 4) Nos interesa saber de antemano cuanto se le debería cobrar a un cliente por un pedido (que son las tareas que pide). 
%Entonces lo que se le cobraría al cliente sería la suma del 
%valor a cobrar por cada tarea, multiplicando el precio por 
%los metros cuadrados de la tarea.

%tareaPedida(tarea, cliente, metrosCuadrados).
tareaPedida(ordenarCuarto, dana, 20).
tareaPedida(cortarPasto, walter, 50).
tareaPedida(limpiarTecho, walter, 70).
tareaPedida(limpiarBanio, louis, 15).

%precio(tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).

cobrar(Cliente,PrecioTotal):-
    tareaPedida(_,Cliente,_),
    % IMPORTANTE como no ligamos la tarea, lo hara con todas las tareas pedidas del cliente!!!!
    findall(Precios, cobrarUnaTarea(Cliente,_,Precios), ListaDePrecios),
    sum_list(ListaDePrecios, PrecioTotal).
    

cobrarUnaTarea(Cliente,Tarea,Precio):-
    tareaPedida(Tarea,Cliente,MetrosCuadrados),
    precio(Tarea,PrecioPorMetroCuadrado),
    Precio is PrecioPorMetroCuadrado * MetrosCuadrados.

% 5)
%Finalmente necesitamos saber quiénes aceptarían el pedido de un cliente. Un integrante acepta el pedido cuando puede realizar todas las tareas
%del pedido y además está dispuesto a aceptarlo.

aceptaElPedido(Cliente, Integrante):-
    cazaFantasma(Integrante),
    tareaPedida(_,Cliente,_),
    pedido(Cliente,Pedido),
    forall(member(Tarea,Pedido),puedeRealizarTarea(Integrante,Tarea)),
    estaDispuestoAAceptar(Cliente,Pedido,Integrante).

pedido(Cliente,Pedido):-
    cazaFantasma(Cliente),
    findall(Tareas, tareaPedida(Tareas,Cliente,_), Pedido).

estaDispuestoAAceptar(_,Pedido,ray):-
    not(member(limpiarTecho,Pedido)).

estaDispuestoAAceptar(Cliente,_,winston):-
    cobrar(Cliente,PrecioTotal),
    PrecioTotal > 500.

estaDispuestoAAceptar(_,Pedido,egon):-
    noTieneTareasComplejas(Pedido).

noTieneTareasComplejas(Pedido):-
    forall(member(Tareas, Pedido), not(tareaCompleja(Tareas))).
/*Decir "para todas las tareas que pidio un cliente, ninguna es compleja"
Equivale a decir "no existe una tarea que haya pedido un 
cliente y que sea compleja"*/

tareaCompleja(limpiarTecho).
tareaCompleja(Tarea):-
    herramientasRequeridas(Tarea,Herramientas),
    length(Herramientas, Cantidad),
    Cantidad > 2.

estaDispuestoAAceptar(_,Pedido,peter):-
    pedido(_,Pedido).

% En la resolucion lo hacen sin lista, directamente trabajando los pedidos como todas las tareas pedidas por un cliente, que es mas facil y ademas si no contamos ni sumamos no hace falta