
% trabajador(nombre, profesion(experiencia,area) ).
trabajador(migue,profesion(maestro,cocinero)).
trabajador(carla,profesion(maestra,alquimista)).
trabajador(feche,profesion(aprendiz,mecanica)).
trabajador(aye,profesion(oficial,alquimista)).
%tiene(nombre,herramienta).
tiene(migue,ollaEssen).
tiene(carla,mechero).
tiene(feche,llaveInglesa).
tiene(aye,piedraFilosofal).


sonCamaradas(Trabajador,OtroTrabajador):-
    trabajador(Trabajador,profesion(_,Area)),
    trabajador(OtroTrabajador,profesion(_,Area)),
    Trabajador \= OtroTrabajador.



inmediatamenteArriba(experto, maestro).
inmediatamenteArriba(oficial, experto).
inmediatamenteArriba(aprendiz, oficial).

masExperiencia(RangoMasAlto,RangoMasBajo):-
    inmediatamenteArriba(RangoMasBajo,RangoMasAlto).
masExperiencia(RangoMasAlto,RangoMasBajo):-
    inmediatamenteArriba(RangoMasBajo,OtroRango),
    masExperiencia(RangoMasAlto,OtroRango).


puedeEntrenarA(Trabajador,OtroTrabajador):-
    sonCamaradas(Trabajador,OtroTrabajador),
    masExperiencia(Trabajador,OtroTrabajador).

puedeHacer(Persona,cocinarMilasConPure):-
    trabajador(Persona,profesion(_,cocinero)).

puedeHacer(Persona,recalentarComida):-
    trabajador(Persona,profesion(_,cocinero)).
puedeHacer(Persona,recalentarComida):-
    tiene(Persona,mechero).

puedeHacer(Persona,producirMedicina(Gramos)):-
    trabajador(Persona,profesion(Experiencia,alquimista)),
    masExperiencia(Experiencia,oficial),
    between(1, 100, Gramos).

puedeHacer(Persona,producirMedicina(_)):-
    trabajador(Persona,profesion(Experiencia,alquimista)),
    masExperiencia(Experiencia,oficial).

puedeHacer(migue,repararAparato(Herramienta)):-
    tiene(_,Herramienta).
puedeHacer(Persona,repararAparato(Herramienta)):-
    trabajador(Persona,profesion(_,mecanica)),
    tiene(Persona,Herramienta).

puedeHacer(Persona,crearObraMaestra(Area)):-
    trabajador(Persona,profesion(maestro,Area)).
puedeHacer(Persona,crearObraMaestra(alquimista)):-
    tiene(Persona,piedraFilosofal).

puedeCubrir(Persona,OtraPersona,Tarea):-
    puedeHacer(Persona,Tarea),
    puedeHacer(OtraPersona,Tarea),
    Persona \= OtraPersona.

esIrremplazable(Persona, Tarea):-
    trabajador(Persona,Tarea),
    not(puedeCubrir(_,Persona,Tarea)).

comodin(Persona):-
    trabajador(Persona,_),
    forall( puedeHacer(_,Tareas),
    puedeHacer(Persona,Tareas) ).
    
