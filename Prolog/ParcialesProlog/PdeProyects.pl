:- use_module(begin_tests_con).

% Les damos parte de la base de conocimientos ya planteada para ahorrarles un poco de tiempo.
% Pueden modificar el predicado como prefieran y/o crear nuevos para implementar los requerimientos
% tarea(Tarea, Estado)
tarea("Como alumno quiero programar en Haskell con los pies", en_progreso).
tarea("Como docente quiero actualizar a Wollok TS", terminada).
tarea("ChatGPT se presento a rendir un parcial", para_hacer).
tarea("Reescribir Linux en Prolog", para_hacer).
tarea("Parciales", en_progreso).
tarea("Como alumno quiero rendir el parcial de funcional", terminada).
tarea("Como alumno quiero rendir el parcial de logico", en_progreso).
tarea("Como alumno quiero rendir el parcial de objetos", para_hacer).
tarea("Elegir un dominio para el parcial de objetos", para_hacer).
tarea("Estudiar el libro de Gamma", para_hacer).
tarea("Como docente quiero cambiar el TP 4 de logico", en_progreso).
tarea("Pensar consignas para el desafío del café con leche", en_progreso).
tarea("Como docente quiero tener un repositorio para los desafíos", para_hacer).


% Parte 1: el equipo y sus tareas

%persona(nombre,rol).
rol(juani,desarrollador(senior)).
rol(emi,devOps).
rol(lucas,desarrollador(junior)).
rol(tomi,desarrollador(semiJunior)).
rol(dante,desarrollador(semiJunior)).
rol(manu,administradorDeBBDD).
rol(gus,administradorDeBBDD).

%asignado(persona,tarea)
asignado(lucas,"Como alumno quiero programar en Haskell con los pies").
asignado(juani,"Como docente quiero actualizar a Wollok TS").
asignado(emi,"Reescribir Linux en Prolog").
asignado(gus,"Parciales").
asignado(tomi,"Como alumno quiero rendir el parcial de funcional").
asignado(lucas,"Como alumno quiero rendir el parcial de logico").
asignado(dante,"Como docente quiero cambiar el TP 4 de logico").
asignado(juani,"Pensar consignas para el desafío del café con leche").
asignado(emi,"Como docente quiero tener un repositorio para los desafíos").

% Queremos saber:
% a) Si una tarea está disponible. Esto ocurre cuando la tarea no tiene a nadie asignado y además su estado es para hacer

estaDisponible(Tarea):-
    tarea(Tarea,para_hacer),
    not(asignado(_,Tarea)).

% b) La dificultad de una tarea para una persona, depende del tipo de tarea y del rol de la persona

tipo("Como alumno quiero programar en Haskell con los pies", historiaDeUsuario(5)).
tipo("Como docente quiero actualizar a Wollok TS",historiaDeUsuario(3)).
tipo("ChatGPT se presento a rendir un parcial",bug).
tipo("Reescribir Linux en Prolog",spike(infraestructura)).
tipo("Parciales",epica).
tipo("Como alumno quiero rendir el parcial de funcional",historiaDeUsuario(4)).
tipo("Como alumno quiero rendir el parcial de logico",historiaDeUsuario(3)).
tipo("Como alumno quiero rendir el parcial de objetos",historiaDeUsuario(6)).
tipo("Elegir un dominio para el parcial de objetos",spike(bibliotecas)).
tipo("Estudiar el libro de Gamma",spike(bibliotecas)).
tipo("Como docente quiero cambiar el TP 4 de logico",historiaDeUsuario(2)).
tipo("Pensar consignas para el desafío del café con leche",spike(bibliotecas)).
tipo("Como docente quiero tener un repositorio para los desafíos",historiaDeUsuario(1)).


dificultad(Tarea,Persona,Dificultad):-
    tarea(Tarea,_),
    rol(Persona,Rol),
    tipo(Tarea,Tipo),
    dificultadSegun(Tipo,Rol,Dificultad).

dificultadSegun(historiaDeUsuario(Tiempo),_,facil):-
    between(1, 3, Tiempo).
dificultadSegun(historiaDeUsuario(4),_,normal).
dificultadSegun(historiaDeUsuario(Tiempo),_,dificil):-
    Tiempo >= 5.

dificultadSegun(bug,Rol,dificil):-
    Rol \= desarrollador(senior).
dificultadSegun(bug,desarrollador(senior),normal).

dificultadSegun(epica,_,dificil).

dificultadSegun(spike(Area),Rol,facil):-
    esCasoEspecial(Area,Rol).
dificultadSegun(spike(Area),Rol,dificil):-
    rol(_,Rol),
    not(esCasoEspecial(Area,Rol)).

esCasoEspecial(infraestructura,devOps).
esCasoEspecial(bibliotecas,desarrollador(_)).
esCasoEspecial(triggers,administradorDeBBDD).

/* predicado anterior
dificultadSegun(spike(_),_,dificil).
dificultadSegun(spike(infraestructura),devOps,facil).
dificultadSegun(spike(bibliotecas),desarrollador(_),facil).
dificultadSegun(spike(triggers),administradorDeBBDD,facil).
*/

% c) Si una persona puede tomar determinada tarea: que es verdad cuando dicha tarea está disponible y no es difícil para la persona.

puedeTomarLaTarea(Persona,Tarea):-
    estaDisponible(Tarea),
    dificultad(Tarea,Persona,Dificultad),
    Dificultad \= dificil.

% Parte 2: squads

%squad(miembro,squad).
squad(tomi,hooligans).
squad(juani,hooligans).
squad(emi,hooligans).
squad(dante,isotopos).
squad(manu,isotopos).
squad(lucas,cools).
squad(gus,cools).

% a) Los puntos entregados del squad. Esto es la sumatoria de horas de las historias de usuario terminadas por los miembros del squad.

puntosDelSquad(Squad,Puntos):-
    obtenerHorasDeListasDeUsuarioDelSquad(Squad,ListaConHoras),
    sum_list(ListaConHoras, Puntos).
    
obtenerHorasDeListasDeUsuarioDelSquad(Squad,ListaDeHorasDelSquad):-
    squad(_,Squad),
    findall(Horas, (squad(Persona,Squad),asignado(Persona,Tarea),tarea(Tarea,terminada),tipo(Tarea,historiaDeUsuario(Horas))), ListaDeHorasDelSquad ).


% b) Si todos los miembros del squad tienen trabajo, lo cual ocurre si todos están ocupados. Un miembro del squad está ocupado si está asignado a alguna tarea que no está finalizada o si puede tomar alguna tarea.

tienenTrabajo(Squad):-
    squad(_,Squad),
    forall(squad(Miembro,Squad),
    estaOcupado(Miembro)).

estaOcupado(Miembro):-
    asignado(Miembro,Tarea),
    tarea(Tarea,Estado),
    Estado \= terminada.
estaOcupado(Miembro):-
    puedeTomarLaTarea(Miembro,_).
    
% c) Cuál es el squad más trabajador, que es, de entre todos los squads en los que todos tienen trabajo, aquel que entrego el máximo número de puntos.

squadMasTrabajador(Squad):-
    tienenTrabajo(Squad),
    puntosDelSquad(Squad,PuntosMaximos),
    forall( (tienenTrabajo(Squads), Squad\=Squads), 
    (puntosDelSquad(Squads,Puntos), PuntosMaximos > Puntos) ).

% Parte 3
subtareaExplicita("Parciales", "Como alumno quiero rendir el parcial de funcional").
subtareaExplicita("Parciales", "Como alumno quiero rendir el parcial de logico").
subtareaExplicita("Parciales", "Como alumno quiero rendir el parcial de objetos").
subtareaExplicita("Como alumno quiero rendir el parcial de objetos", "Elegir un dominio para el parcial de objetos").
subtareaExplicita("Como alumno quiero rendir el parcial de objetos", "Estudiar el libro de Gamma").
subtareaExplicita("Pensar consignas para el desafío del café con leche", "Como docente quiero tener un repositorio para los desafíos").

% a) el número de subtareas total de una tarea. Esto tiene en cuenta tanto las subtareas explícitas de la misma como las subtareas de sus subtareas (poner ejemplo).

esSubtarea(Tarea,Subtarea):-
    tarea(Tarea,_),
    tarea(Subtarea,_),
    subtareaExplicita(Tarea,Subtarea).

esSubtarea(Tarea,Subtarea):-
    tarea(Tarea,_),
    tarea(TareaIntermedia,_),
    subtareaExplicita(Tarea,TareaIntermedia),
    esSubtarea(TareaIntermedia,Subtarea).

cantidadDeSubtareas(Tarea,Cantidad):-
    tarea(Tarea,_),
    findall(Subtareas, esSubtarea(Tarea,Subtareas),ListaDeSubtareas),
    length(ListaDeSubtareas, Cantidad).
    
% b) cuáles tareas se encuentran mal catalogadas, teniendo en cuenta que se recomienda que, si una tarea tiene al menos una subtarea en total, sea considerada una historia de usuario o una épica, y que si tiene al menos cinco subtareas en total, sea considerada una épica.
malCatalogada(Tarea):-
    cantidadDeSubtareas(Tarea,Subtareas),
    between(1, 4, Subtareas),
    not(esHistoriaDeUsuarioOEpica(Tarea)).

malCatalogada(Tarea):-
    cantidadDeSubtareas(Tarea,Subtareas),
    Subtareas >= 5,
    tipo(Tarea,Tipo),
    Tipo \= epica.

esHistoriaDeUsuarioOEpica(Tarea):-
    tipo(Tarea,historiaDeUsuario(_)).
esHistoriaDeUsuarioOEpica(Tarea):-
    tipo(Tarea,epica).



:- begin_tests_con(parcial, []).

test("Una tarea esta disponible si no tiene a nadie asignado y su estado es para hacer", nondet):-
    estaDisponible("ChatGPT se presento a rendir un parcial").

test("Una tarea esta disponible si no tiene a nadie asignado y su estado es para hacer", nondet):-
    estaDisponible("Elegir un dominio para el parcial de objetos").

test("Una tarea no esta disponible si tiene a alguien asignado y su estado es para hacer", nondet):-
    not(estaDisponible("Reescribir Linux en Prolog")).

test("Una tarea no esta disponible si tiene a alguien asignado y su estado es para hacer", nondet):-
    not(estaDisponible("Como docente quiero tener un repositorio para los desafíos")).

test("La dificultad de una tarea de tipo historia de usuario que tarda entre 1 y 3 horas es facil, no importa el rol de la persona", nondet):-
    dificultad("Como docente quiero cambiar el TP 4 de logico",emi,facil).

test("La dificultad de una tarea de tipo historia de usuario que tarda 4 horas es normal, no importa el rol de la persona", nondet):-
    dificultad("Como alumno quiero rendir el parcial de funcional",juani,normal).

test("La dificultad de una tarea de tipo historia de usuario que tarda mas de 5 horas es dificil, no importa el rol de la persona", nondet):-
    dificultad("Como alumno quiero rendir el parcial de objetos",dante,dificil).

test("La dificultad de una tarea de tipo bug para un desarrollador Senior es normal", nondet):-
    dificultad("ChatGPT se presento a rendir un parcial",juani,normal).

test("La dificultad de una tarea de tipo bug para cualquier persona que no sea un desarrollador Senior es dificil", nondet):-
    dificultad("ChatGPT se presento a rendir un parcial",lucas,dificil).

test("La dificultad de una tarea de spike de infraestructua para un devOps es facil", nondet):-
    dificultad("Reescribir Linux en Prolog",emi,facil).

test("La dificultad de una tarea de spike de infraestructua para alguien que no es devOps es dificil", nondet):-
    dificultad("Reescribir Linux en Prolog",juani,dificil).

test("La dificultad de una tarea de spike de bibliotecas para un desarrollador es facil", nondet):-
    dificultad("Estudiar el libro de Gamma",juani,facil).

test("La dificultad de una tarea de spike de bibliotecas para un devOp es dificil", nondet):-
    dificultad("Estudiar el libro de Gamma",emi,dificil).

test("La dificultad de una tarea de spike de bibliotecas para un administrador de BBDD es dificil", nondet):-
    dificultad("Estudiar el libro de Gamma",manu,dificil).

test("La dificultad de una tarea de tipo epica siempre es dificil", nondet):-
    dificultad("Parciales",manu,dificil).

test("La dificultad de una tarea de tipo epica siempre es dificil", nondet):-
    dificultad("Parciales",emi,dificil).

test("Una persona puede tomar una tarea que está disponible y no es difícil para la persona", nondet):-
    puedeTomarLaTarea(juani,"ChatGPT se presento a rendir un parcial").

test("Una persona puede tomar una tarea que está disponible y no es difícil para la persona", nondet):-
    puedeTomarLaTarea(lucas,"Elegir un dominio para el parcial de objetos").

test("el número de subtareas total de una tarea, que incluye tanto las subtareas explícitas de la misma como las subtareas de sus subtareas", nondet):-
    cantidadDeSubtareas("Parciales",5).


:- end_tests(parcial).
