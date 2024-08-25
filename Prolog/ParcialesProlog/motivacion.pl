
% 1) Agregar hechos

necesidad(respiracion, fisiologico). 
necesidad(descanso, fisiologico). 
necesidad(alimentacion, fisiologico). 
necesidad(integridad, seguridad).
necesidad(empleo, seguridad). 
necesidad(salud, seguridad).

necesidad(amistad,social).
necesidad(intimidad,social).
necesidad(afecto,social).

necesidad(confianza, reconocimiento).
necesidad(respeto, reconocimiento).
necesidad(exito, reconocimiento).

necesidad(libertad,autorrealizacion).

nivelSuperior(autorrealizacion, reconocimiento). 
nivelSuperior(reconocimiento, social).
nivelSuperior(social, seguridad).
nivelSuperior(seguridad, fisiologico).

% 2) Permitir averiguar la separación de niveles que hay entre dos necesidades, es decir la cantidad de niveles que hay entre una y otra.

separacion(Necesidad, OtraNecesidad, Separacion):-
    necesidad(Necesidad, Nivel),
    necesidad(OtraNecesidad, OtroNivel),
    %nivelSuperior(Nivel,OtroNivel),
    separacionNivel(Nivel,OtroNivel,Separacion).

separacionNivel(Nivel,Nivel,0).

separacionNivel(Nivel, OtroNivel, Separacion):-
    nivelSuperior(OtroNivel,NivelAux),
    separacionNivel(Nivel,NivelAux, SeparacionAnterior),
    Separacion is SeparacionAnterior + 1.

% 3) Modelar las necesidades (sin satisfacer) de cada persona.

necesita(carla,alimentacion).
necesita(carla,descanso).
necesita(carla,empleo).
necesita(juan,afecto).
necesita(juan,exito).
necesita(roberto,amistad).
necesita(manuel,libertad).
necesita(charly,afecto).

% 4) Encontrar la necesidad de mayor jerarquía de una persona.

necesidadDeMayorJerarquia(Persona,NecesidadMayor):-
    necesita(Persona,NecesidadMayor),
    forall( (necesita(Persona,Necesidades), Necesidades \= NecesidadMayor), 
    mayorJeararquia(Necesidades, NecesidadMayor)).
    
mayorJeararquia(NecesidadMayor,Necesidad):-
    separacion(NecesidadMayor, Necesidad, Separacion),
    Separacion > 0.

% 5) Saber si una persona pudo satisfacer por completo algún nivel de la pirámide.

completoNivel(Persona,Nivel):-
    necesita(Persona,_),
    necesidad(_,Nivel),
    forall( necesidad(Necesidades,Nivel), 
    not(necesita(Persona,Necesidades))).

/* Opcion con listas
satisfacerNivel(Persona, Nivel):-
    necesita(Persona, _), 
    necesidad(_, Nivel),
    findall(Necesidad, necesidad(Necesidad, Nivel), NecesidadesNivel),
    forall(member(Necesidad, NecesidadesNivel), not(necesita(Persona, Necesidad))). */
    