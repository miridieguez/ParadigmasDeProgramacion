

% 1) a. Modelar la relación entre personas y mascotas con la información descripta, y agregar a la base de conocimientos los ejemplos mencionados.


tieneMascota(martin,adopto, pepa,2014).
tieneMascota(martin,adopto,frida,2015).
tieneMascota(martin,adopto,kali,2016).
tieneMascota(martin,adopto,olivia,2014).
tieneMascota(martin,compro,piru,2010).

tieneMascota(constanza,regalo,abril,2006).
tieneMascota(constanza,adopto,mambo,2015).

% para el ejemplo del 7.
tieneMascota(constanza,compro,aaa,2015).
tieneMascota(constanza,compro,bbb,2019).
tieneMascota(constanza,compro,ccc,2016).

tieneMascota(hector,adopto,abril,2015).
tieneMascota(hector,adopto,mambo,2015).
tieneMascota(hector,adopto,buenaventura,1971).
tieneMascota(hector,adopto,severino,2007).
tieneMascota(hector,adopto,simon,2016).
tieneMascota(hector,compro,abril,2006).

tieneMascota(silvio,regalo,quinchin,1990).

tieneMascota(miri,compro,second,2021).

% perro(tamaño)
% gato(sexo, cantidad de personas que lo acariciaron)
% tortuga(carácter)

mascota(second, perro(mediano)).

mascota(pepa, perro(mediano)).
mascota(frida, perro(grande)).
mascota(piru, gato(macho,15)).
mascota(kali, gato(macho,3)).
mascota(olivia, gato(hembra,16)).
mascota(mambo, gato(macho,2)).
mascota(abril, gato(hembra,4)).
mascota(buenaventura, tortuga(agresiva)).
mascota(severino, tortuga(agresiva)).
mascota(simon, tortuga(tranquila)).
mascota(quinchin, gato(macho,0)).

/*tipoDeMascota(Mascota,Tipo):-
    mascota(Mascota,gato(_,_)),
    Tipo is gato.*/

% 2) comprometidos/2 se cumple para dos personas cuando adoptaron el mismo año a la misma mascota. 

comprometidos(Persona,OtraPersona):-
    tieneMascota(Persona,adopto,Mascota,Anio),
    tieneMascota(OtraPersona,adopto,Mascota,Anio),
    Persona \= OtraPersona.

% 3) locoDeLosGatos/1 se cumple para una persona cuando tiene sólo gatos, pero más de uno.

locoDeLosGatos(Persona):-
    tieneMascota(Persona,_,_,_),
    tieneMasDeUn(gato,Persona),
    forall( tieneMascota(Persona,_,Mascotas,_) , 
    esunGato(Mascotas)).
    
esunGato(Mascota):-
    mascota(Mascota, gato(_,_)).

tieneMasDeUn(gato,Persona):-
    tieneMascota(Persona,_,Mascota,_),
    tieneMascota(Persona,_,OtraMascota,_),
    esunGato(Mascota),
    esunGato(OtraMascota),
    Mascota \= OtraMascota.

% 4) puedeDormir/1 Se cumple para una persona si no tiene mascotas que estén chapita
puedeDormir(Persona):-
%  no existe una mascota chapita -->  todas mascotas no estan chapitas       
    tieneMascota(Persona,_,_,_),
    not((tieneMascota(Persona,_,Mascota,_), estaChapita(Mascota))).
    
estaChapita(Mascota):-
    mascota(Mascota, gato(macho,Acariciadas)),
    Acariciadas < 10.
estaChapita(Mascota):-
    mascota(Mascota,perro(chico)).
estaChapita(Mascota):-
    mascota(Mascota, tortuga(_)).

% 5) A veces las personas siguen llevando mascotas a sus casas a pesar de tener mascotas chapitas. 
% a) crisisNerviosa/2 es cierto para una persona y un año cuando, el año anterior obtuvo una mascota que está chapita y ya antes tenía otra mascota que está chapita.
crisisNerviosa(Persona,Anio):-
    tieneMascota(_,_,_,AnioQueQueremos),
    AnioQueQueremos is (Anio - 1),
    tieneMascota(Persona,_,Mascota1,AnioQueQueremos),
    estaChapita(Mascota1),
    tieneMascota(Persona,_,Mascota2,AnioAnterior),
    estaChapita(Mascota2),
    AnioAnterior < AnioQueQueremos,
    Mascota1 \= Mascota2.

% b) mascotaAlfa/2 Relaciona una persona con el nombre de una mascota, cuando esa mascota domina al resto de las mascotas de esa persona. 
mascotaAlfa(Persona,Mascota):-
    tieneMascota(Persona,_,Mascota,_),
    mascota(Mascota,_),
    forall( (tieneMascota(Persona,_,Mascotas,_), Mascota\=Mascotas ),
    domina(Mascota,Mascotas)).

domina(gato(_,_),perro(_)).
domina(perro(grande),perro(chico)).
domina(Gato1,Gato2):-
    estaChapita(Gato1),
    not(estaChapita(Gato2)).
domina(tortuga(agresiva),_).

% materialista/1 se cumple para una persona cuando no tiene mascotas o compró más de las que adoptó. 
materialista(Persona):-
    tieneMascota(Persona,_,_,_),
    findall(MascotaComprada, tieneMascota(Persona,compro,MascotaComprada,_), Compradas),
    length(Compradas, CantidadDeMascotasCompradas),
    findall(MascotaAdoptada,  tieneMascota(Persona,adopto,MascotaAdoptada,_), Adoptadas),
    length(Adoptadas, CantidadDeMascotasAdoptadas),
    CantidadDeMascotasCompradas > CantidadDeMascotasAdoptadas.

