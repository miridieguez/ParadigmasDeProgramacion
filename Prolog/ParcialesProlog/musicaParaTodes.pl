

% disco(artista, nombreDelDisco, cantidad, año).
disco(floydRosa, elLadoBrillanteDeLaLuna, 1000000, 1973).
disco(tablasDeCanada, autopistaTransargentina, 500, 2006).
disco(rodrigoMalo, elCaballo, 5000000, 1999).
disco(rodrigoMalo, loPeorDelAmor, 50000000, 1996).
disco(rodrigoMalo, loMejorDe, 50000000, 2018).
disco(losOportunistasDelConurbano, ginobili, 5, 2018).
disco(losOportunistasDelConurbano, messiMessiMessi, 5, 2018).
disco(losOportunistasDelConurbano, marthaArgerich, 15, 2019).

% para el ejemplo
%disco(laliTeAmo, soy, 1500, 2019).
%disco(laliTeAmo, caca, 1500, 2018).



%manager(artista, manager).
manager(floydRosa, normal(15)).
manager(tablasDeCanada, buenaOnda(cachito, canada)).
manager(rodrigoMalo, estafador(tito)).

% habitual(porcentajeComision) 
% internacional(nombre, lugar)
% trucho(nombre)     

% 1. clasico Permite deducir si un artista tiene un disco llamado loMejorDe o alguno con más de 100000 de copias vendidas.

clasico(Artista):-
    disco(Artista,loMejorDe,_,_).

clasico(Artista):-
    disco(Artista,_,CopiasVendidas,_),
    CopiasVendidas > 100000.

% 2. cantidadesVendidas Relaciona un artista con la cantidad total de unidades vendidas en la historia.

cantidadesVendidas(Artista,UnidadesVendidas):-
    disco(Artista,_,_,_),
    findall(Unidades, disco(Artista,_,Unidades,_),UnidadesVendidasPorDisco),
    sum_list(UnidadesVendidasPorDisco,UnidadesVendidas).
    

% 3. derechosDeAutor Relaciona a un artista con importe total en concepto de derechos de autor.  

% sin manager
derechosDeAutor(Artista,ImporteTotal):-
    disco(Artista,_,_,_),
    noTieneManager(Artista),
    importePorCantidadesVendidas(Artista, ImporteTotal).

% con manager
derechosDeAutor(Artista,ImporteTotal):-
    disco(Artista,_,_,_),
    manager(Artista,Manager),
    importePorCantidadesVendidas(Artista, Importe),
    descuentoDelManager(Manager, Importe, LoQueSeLlevaElManajer),
    ImporteTotal is (Importe - LoQueSeLlevaElManajer).

importePorCantidadesVendidas(Artista,Importe):-
    cantidadesVendidas(Artista, Cantidad),
    Importe is Cantidad * 100.

% habitual
descuentoDelManager(normal(PorcentajeComision),Importe, LoQueSeLlevaElManajer):-
    seLlevaElManajer(Importe,PorcentajeComision,LoQueSeLlevaElManajer).

% internacional
descuentoDelManager(buenaOnda(_,Lugar),Importe, LoQueSeLlevaElManajer):-
    porcentajePorLugar(Lugar,Porcentaje),
    seLlevaElManajer(Importe,Porcentaje,LoQueSeLlevaElManajer).

% trucho
descuentoDelManager(estafador(_),Importe,LoQueSeLlevaElManajer):-
    seLlevaElManajer(Importe, 100 ,LoQueSeLlevaElManajer).

% calculo de lo que se lleva el manajer
seLlevaElManajer(Importe,Porcentaje,LoQueSeLlevaElManajer):-
    LoQueSeLlevaElManajer is Importe * (Porcentaje / 100).

porcentajePorLugar(canada, 5).
porcentajePorLugar(mexico, 15).

noTieneManager(Artista):-
    disco(Artista,_,_,_),
    not(manager(Artista,_)).

%  4.	namberuan Encontrar al artista autogestionado número 1 de un año, que es el artista sin manager con el disco que tuvo más unidades vendidas en dicho año. 
namberuan(Artista,Anio):-
    noTieneManager(Artista),
    disco(Artista,_,Venta,Anio),
    forall( (disco(Artistas,_,Ventas,Anio), Artistas\=Artista, noTieneManager(Artistas) ),
    Venta > Ventas ).