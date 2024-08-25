% Lógica de negocio

% Punto 1: calentando motores (2 puntos)
% Definir la relación para asociar cada persona con el rango horario que cumple

persona(dodain).
persona(lucas).
persona(juanC).
persona(leoC).
persona(maiu).
persona(valen).
persona(maiu).

dia(lunes).
dia(martes).
dia(miercoles).
dia(jueves).
dia(viernes).
dia(sabado).
dia(domingo).


horario(dodain,lunes,9,15).
horario(dodain,miercoles,9,15).
horario(dodain,viernes,9,15).

horario(lucas,martes,10,20).

horario(juanC,sabado,18,22).
horario(juanC,domingos,18,22).

horario(juanFdS,jueves,10,20).
horario(juanFdS,viernes,12,20).

horario(leoC,lunes,14,18).
horario(leoC,miercoles,14,18).

horario(martu,miercoles,23,24).

horario(vale,Dia,ComienzoTurno,FinTurno):-
  horario(dodain,Dia,ComienzoTurno,FinTurno).
horario(vale,Dia,ComienzoTurno,FinTurno):-
  horario(juanC,Dia,ComienzoTurno,FinTurno).

horario(maiu,martes,0,8).
horario(maiu,miercoles,0,8).

% nadie hace el mismo horario que leoC
% esto no hace falta representarlo por universo cerrado

% Punto 2: quién atiende el kiosko
% Definir un predicado que permita relacionar un día y hora con una persona, en la que dicha persona atiende el kiosko. 

quienAtiendeElKiosko(Dia,Hora,Kioskero):-
  horario(Kioskero,Dia,ComienzoTurno,FinTurno),
  between(ComienzoTurno, FinTurno, Hora).
  
%Punto 3: Forever alone (2 puntos)
%Definir un predicado que permita saber si una persona en un día y horario determinado está atendiendo ella sola. 

foreverAlone(Kioskero,Dia,Hora):-
  quienAtiendeElKiosko(Dia,Hora,Kioskero),
  not(hayMasDeUnoAtendiendo(Dia,Hora)).

hayMasDeUnoAtendiendo(Dia,Hora):-
  quienAtiendeElKiosko(Dia,Hora,Kioskero),
  quienAtiendeElKiosko(Dia,Hora,OtroKioskero),
  Kioskero \= OtroKioskero.

% Punto 4: posibilidades de atención 
% Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko en algún momento de ese día.
%quienPodriaEstarAtendiendo(Dia,Kioskero):-
% quienAtiendeElKiosko(Dia,_,Kioskero).

% Por ejemplo, si preguntamos por el miércoles, tiene que darnos esta combinatoria:
%nadie
%dodain solo
%dodain y leoC
%dodain, vale, martu y leoC
%vale y martu
%etc.

% Punto 5: ventas / suertudas 

venta(dodain,lunes,(10,8),[golosinas(1200), golosinas(50), cigarrillos([jockey])]).
venta(dodain,miercoles,(12,8),[bebidas(alcoholicas,8),bebidas(noAlcoholicas,1),golosinas(10)]).
venta(martu,miercoles,(12,8),[golosinas(1000),cigarrillos([chesterfield,colorado,parisiennes])]).
venta(lucas,martes,(11,8),[golosinas(600)]).
venta(lucas,martes,(18,8),[bebidas(noAlcoholicas,2),cigarrillos([derby])]).
% elegimos listas porque necesitamos LA PRIMER VENTA, y asi se hace mas facil

% Queremos saber si una persona vendedora es suertuda, esto ocurre si para todos los días en los que vendió, 
% la primera venta que hizo fue importante. 

esSuertudo(Kioskero):-
  venta(Kioskero,_,_,_),
  forall(venta(Kioskero,_,_,[Venta|_]), esImportante(Venta)).
% importante que las primeras ventas de todos los dias van a machear aca porque las dividimos por dias, no hace falta buscar por dia

  esImportante(golosinas(Precio)):-
    Precio > 100.
  esImportante(cigarrillos(Marcas)):-
    length(Marcas, Numero),
    Numero > 2.
  esImportante(bebidas(alcoholicas,_)).
  esImportante(bebidas(_,Cantidad)):-
    Cantidad > 5.