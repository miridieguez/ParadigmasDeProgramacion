:- use_module(begin_tests_con).

%persona(nombre)
persona(juan).
persona(aye).
persona(feche).

% Fechas de cumpleaños

nacio(juan,(9,7,1994)).
nacio(aye,(26,3,1992)).
nacio(feche,(22,12,1995)).

fecha(dia,mes,anio):-
    between(1, 31, dia),
    between(1,12,mes),
    between(0,2024,anio).

% 1. Y queremos saber:

% a) si una fecha es antes que otra.

esAnteriorA((_,_,Anio),(_,_,OtroAnio)):-
    Anio < OtroAnio.
esAnteriorA((_,Mes,Anio),(_,OtroMes,Anio)):-
    Mes < OtroMes.
esAnteriorA((Dia,Mes,Anio),(OtroDia,Mes,Anio)):-
    Dia < OtroDia.

% b) si ya pasó el cumpleaños de alguien en cierta fecha.
pasoElCumpleDe(Persona,(DiaActual,MesActual,_)):-
    nacio(Persona,(Dia,Mes,Anio)),
    esAnteriorA((Dia,Mes,Anio),(DiaActual,MesActual,Anio)).

% A quién puede regalar

% 2. Es por eso que queremos, dada una fecha, saber quien podría regalarle a quién. 

puedeRegalar((DiaActual,MesActual,AnioActual),Regalador,Receptor):-
    persona(Regalador),
    persona(Receptor),
    not(regaloEsteAnio(Regalador,AnioActual)),
    not(pasoElCumpleDe(Receptor,(DiaActual,MesActual,AnioActual))),
    not(recibioRegalosEsteAnio(Receptor,AnioActual)).

regaloEsteAnio(Regalador,Anio):-
    regalo(Regalador,_,_,Anio).

recibioRegalosEsteAnio(Receptor,Anio):-
    regalo(_,Receptor,_,Anio).

% libro(genero, autor).
% producto(temática).
% cerveza(marca, sabor)

%regalo(regalador, receptor, regalo, año).
regalo(juan, feche, libro(fantasia, terryPratchet), 2018).
regalo(juan, aye, producto(harryPotter), 2019).
regalo(juan, aye, cerveza(artesanal, roja), 2020).
regalo(juan, feche, cerveza(quilmes, rubia), 2021).

regalo(aye, feche, libro(fantasia, terryPratchet), 2019).
regalo(aye, juan, libro(cienciaFiccion, stanislawLem), 2020).

regalo(feche, juan, cerveza(artesanal, rubia), 2019).
regalo(feche, juan, producto(pokemon), 2020).
regalo(feche, aye, libro(terror, maryShelley), 2021).


%Buenos regalos

% 3. Lo que necesitamos poder contestar es si un regalo de un amigo invisible fue un buen regalo para una persona.
% Esto se cumple si el regalo le gustaba a la persona que lo recibió. 

% gustos
leGusta(aye, cerveza(heineken,rubia)).
leGusta(aye, producto(harryPotter)).

leGusta(juan, libro(fantasia,_)).
leGusta(juan, libro(cienciaFiccion,_)).
leGusta(juan,Regalo):-
    esCaro(Regalo).

leGusta(feche,producto(monsterHunter)).
leGusta(feche,libro(Genero,terryPratchet)):-
    not(esCaro(libro(Genero,terryPratchet))).

esCaro(libro(cienciaFiccion,rayBradbury)).
esCaro(libro(novela,_)).
esCaro(cerveza(artesanal,_)).

fueBuenoElRegalo(Regalo,Regalador,Receptor):-
    regalo(Regalador,Receptor,Regalo,_),
    leGusta(Receptor,Regalo).


% Hábil regalador

% 4. Queremos saber quienes son hábiles regaladores, lo cual se cumple si siempre hicieron buenos regalos 
% y además nunca hicieron 2 regalos parecidos en distintos años.

% sonParecidos(regalo,regalo).
sonParecidos(cerveza(_,_),cerveza(_,_)).
sonParecidos(libro(Genero,_),libro(Genero,_)).
sonParecidos(producto(Tematica),producto(Tematica)).

habilRegalador(Persona):-
    persona(Persona),
    siempreHizoBuenosRegalos(Persona),
    not(hizoRegalosParecidosEnDistintoAnio(Persona)).
    
siempreHizoBuenosRegalos(Regalador):-
    forall(regalo(Regalador,_,Regalos,_),fueBuenoElRegalo(Regalos,Regalador,_)).

hizoRegalosParecidosEnDistintoAnio(Persona):-
    regalo(Persona,_,Regalo,Anio),
    regalo(Persona,_,OtroRegalo,OtroAnio),
    Regalo \= OtroRegalo,
    Anio \= OtroAnio,
    sonParecidos(Regalo,OtroRegalo).

% Monotemático

% 5. Decimos que alguien es monotemático cuando todos los regalos que recibió y le gustaron eran parecidos entre sí.

% IMPORTANTE: Cuando tenes muchos elementos y tenes que comparar solo cierta cantidad (en este caso dos), 
% se puede hacer otra relacion para buscar esa cantidad de elementos y despues llamar a esa relacion en el forall
% para no tener que meter todo en el forall.
% Aca estan las dos opciones:

esMonotematico(Persona):-
    persona(Persona),
    forall((fueBuenoElRegalo(Regalos,_,Persona),fueBuenoElRegalo(Regalo,_,Persona),
    Regalos \= Regalo),
    sonParecidos(Regalo, Regalos)).

/*
esMonotematico(Receptor):-
    persona(Receptor),
    forall(recibirDosRegalosBuenosDistintos(Receptor,Regalo,OtroRegalo),
    %si tiene menos de dos regalos da verdadero, por la regla del condicional F->? da V
    sonParecidos(Regalo, OtroRegalo)).

recibirDosRegalosBuenosDistintos(Receptor,Regalo,OtroRegalo):-
    %regalo(_,Receptor,Regalo,_),
    %regalo(_,Receptor,OtroRegalo,_),
    fueBuenoElRegalo(Regalo,Receptor),
    fueBuenoElRegalo(OtroRegalo,Receptor),
    Regalo \= OtroRegalo.*/
    

/* Regalador Ninja
    
6. Un regalo ninja es aquel que se hace con la intención de uno mismo usar el regalo que se le hizo a la otra persona. 
Entonces, teniendo un regalador y un regalado, un regalo es regalo ninja si el regalador se lo regaló al regalado y además el 
regalo le gustaba al regalador (si le gustaba o no al regalado no importa)*/
    
    %regalo(regalador, receptor, regalo, año).
regaloNinja(Regalo,Regalador,Receptor):-
    regalo(Regalador, Receptor,Regalo,_),
    leGusta(Regalador,Regalo).

% Queremos saber quien es regalador ninja: que es aquel que hizo tantos o más regalos ninja que buenos regalos.
% Nota: Tener en cuenta que un mismo regalo que haya hecho podría contar tanto como regalo ninja y como buen regalo.

regaladorNinja(Regalador):-
    persona(Regalador),
    cantidadDeRegalosNinjaQueHizo(Regalador,RegalosNinja),
    cantidadDeRegalosBuenosQueHizo(Regalador,RegalosBuenos),
    RegalosNinja >= RegalosBuenos.

cantidadDeRegalosNinjaQueHizo(Regalador,Cantidad):-
    regalosNinjaQueHizo(Regalador, ListaDeRegalosNinja),
    length(ListaDeRegalosNinja , Cantidad).

cantidadDeRegalosBuenosQueHizo(Regalador,Cantidad):-
regalosBuenosQueHizo(Regalador, ListaDeRegalosBuenos),
    length( ListaDeRegalosBuenos, Cantidad).

regalosNinjaQueHizo(Regalador,ListaDeRegalosNinja):-
    persona(Regalador),
    findall(Regalo,regaloNinja(Regalo,Regalador,_),ListaDeRegalosNinja).

regalosBuenosQueHizo(Regalador,ListaDeRegalosBuenos):-
    persona(Regalador),
    findall(Regalo,fueBuenoElRegalo(Regalo,Regalador,_),ListaDeRegalosBuenos).
