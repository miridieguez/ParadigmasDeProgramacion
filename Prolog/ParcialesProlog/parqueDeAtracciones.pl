
% Parque de atracciones


%persona(nombre, rangoEtario, edad, altura).
persona(nina, joven, 22, 1.60).
persona(marcos, ninio, 8, 1.32).
persona(osvaldo, adolescente, 13, 1.29).

%pasaporte(nombre, tipoDePasaporte, creditos).
pasaporte(nina, basico, 50).
pasaporte(nina, flex(maquinaTiquetera), 50).


% atraccion(nombre, parque)
atraccion(trenFantasma, parqueDeLaCosta).
atraccion(montaniaRusa, parqueDeLaCosta).
atraccion(maquinaTiquetera, parqueDeLaCosta).

%tipoDelJuego(nombre,Tipo).
tipoDelJuego(trenFantasma,comun(50)).

%edadMinima(juego, edadMinima)
edadMinima(trenFantasma,12).
alturaMinima(montaniaRusa, 1.30).
alturaMinima(toboganGiganteLaOlaAzul, 1.50).
edadMinima(piscinaDeOlasMaremoto,5).

%atraccion(nombre, parque)
atraccion(toboganGiganteLaOlaAzul, parqueAcuatico).
atraccion(rioLentoCorrienteSerpenteante, parqueAcuatico).
atraccion(piscinaDeOlasMaremoto, parqueAcuatico).

% puedeSubir/2, relaciona una persona con una atracción, si la persona puede subir a la atracción.

puedeSubir(Persona, Atraccion):-
    persona(Persona,_,Edad,Altura),
    atraccion(Atraccion,_),
    edadMinima(Atraccion, EdadMinima),
    alturaMinima(Atraccion, AlturaMinima),
    Edad >= EdadMinima,
    Altura >= AlturaMinima,
    tieneAcceso(Persona,Atraccion).

puedeSubir(Persona, maquinaTiquetera):-
    persona(Persona,_,_,_).

puedeSubir(Persona, rioLentoCorrienteSerpenteante):-
    persona(Persona,_,_,_).

%pasaporte flex
%ojo uso de or
tieneAcceso(Persona,Atraccion):-
    pasaporte(Persona,flex(Juego),Creditos),
    (tipoDelJuego(Atraccion,premium),
    Juego == Atraccion;
    tipoDelJuego(Juego,comun(CreditosNecesarios)),
    Creditos >= CreditosNecesarios).
% Otra opcion es poner flex(juegoPermitdo(Juego)) y ahi podes poner Juego = juegoPermitido(Atraccion)). 


%pasaporte basico
tieneAcceso(Persona,Atraccion):-
    pasaporte(Persona,basico,Creditos),
    tipoDelJuego(Atraccion,comun(CreditosNecesarios)),
    Creditos >= CreditosNecesarios.

%pasaporte premium
tieneAcceso(Persona,Atraccion):-
    pasaporte(Persona, premium,_),
    atraccion(Atraccion,_).


% esParaElle/2, relaciona un parque con una persona, si la persona puede subir a todos los juegos del parque.
esParaElle(Persona, Parque):-
    persona(Persona,_,_,_),
    atraccion(_, Parque),
    forall( atraccion(Atracciones,Parque),
    puedeSubir(Persona, Atracciones)).
    
% malaIdea/2, relaciona un grupo etario (adolescente/niño/joven/adulto/etc) con un parque, y nos dice que "es mala idea" que las personas de ese 
% grupo vayan juntas a ese parque, si es que no hay ningún juego al que puedan subir todos.

malaIdea(GrupoEtario, Parque):-
    persona(_,GrupoEtario,_,_),
    forall( persona(Personas,GrupoEtario,_,_),
    not(puedeSubirAUnaAtraccion(Personas, Parque)) ).

puedeSubirAUnaAtraccion(Persona, Parque):-
    persona(Persona,_,_,_),
    atraccion(Atraccion,Parque),
    puedeSubir(Persona, Atraccion).
% Ojo que este no me salio. La idea es que dentro del forall hay que CREAR una funcion que relacione personas con un parque y dentro 
% de esa funcion ligamos la atraccion. No funciona de otra forma. Crear funciones que relacionen otros individuos.

% Programas
%Un programa es una lista ordenada de atracciones, que tienen que estar todas en el mismo parque.
programa([olaAzul, maremoto, corrienteSerpenteante]). 
programa([olaAzul, corrienteSerpenteante, maremoto]).
programa([olaAzul, trenFantasma, maremoto]). 
programa([trenFantasma, montanaRusa, maquinaTiquetera, trenFantasma]).
programa([trenFantasma, montanaRusa]).
programa([montanaRusa, maquinaTiquetera,trenFantasma,piscinaDeOlasMaremoto]).


% programaLogico/1, me dice si un programa es "bueno", es decir, todos los juegos están en el mismo parque y no hay juegos repetidos.
programaLogico(Programa):-
    programa(Programa),
    todasLasAtraccionesSonDeUnMismoParque(Programa),
    noHayRepetidos(Programa).

todasLasAtraccionesSonDeUnMismoParque([Atraccion|Atracciones]):-
    atraccion(Atraccion,Parque), % tenemos que obtener el parque al que van a pertenecer todos los demas si o si, si no va a iterar
    forall( member(RestoDeAtracciones, Atracciones), 
    atraccion(RestoDeAtracciones, Parque) ).

noHayRepetidos([]).
noHayRepetidos([Atraccion|Atracciones]):-
    not(member(Atraccion,Atracciones)),
    noHayRepetidos(Atracciones).

% hastaAca/3, relaciona a una persona P y un programa Q, con el subprograma S que se compone de las atracciones iniciales de Q hasta la primera 
% a la que P no puede subir (excluida obviamente).

hastaAca(Persona,Programa,Subprograma):-
    persona(Persona,_,_,_),
    programa(Programa),
    armarNuevaListaConAtraccionesPosibles(Persona,Programa,Subprograma).

armarNuevaListaConAtraccionesPosibles(Persona, ListaDeAtracciones, Subprograma):-
    persona(Persona,_,_,_),
    findall(AtraccionesPosibles, (member(AtraccionesPosibles,ListaDeAtracciones), 
    puedeSubir(Persona , AtraccionesPosibles)), Subprograma).

