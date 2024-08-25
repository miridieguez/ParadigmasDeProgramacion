
% restaurante(nombre, cantidadDeEstrellas, barrio).

restaurante(panchoMayo, 2, barracas).
restaurante(finoli, 3, villaCrespo).
restaurante(superFinoli, 5, villaCrespo).
restaurante(noTanFinoli, 0, villaCrespo).


%menu(nombre, carta( precio , descripcionDelPlato )).
menu(panchoMayo, carta(1000, pancho)).
menu(panchoMayo, carta(200, hamburguesa)).
menu(finoli, carta(2000, hamburguesa)).

%menu(nombre, pasos( cantidadDePasos , precio, listaDeVinos, comensales )).
menu(finoli, pasos(15, 15000, [chateauMessi, francescoliSangiovese, susanaBalboaMalbec], 6)).
menu(noTanFinoli, pasos(2, 3000, [guinoPin, juanaDama],3)).

%vino(nombre, paísDeOrigen, costo).
vino( chateauMessi, francia, 5000).
vino( francescoliSangiovese, italia, 1000).
vino( susanaBalboaMalbec, argentina, 1200).
vino( christineLagardeCabernet, argentina, 5200).
vino( guinoPin, argentina, 500).
vino( juanaDama, argentina, 1000).

%  Se pide saber

% 1) Cuáles son los restaurantes de más de N estrellas por barrio.

restauranteDeMasDeNEstrellas(EstrellasNecesarias,Restaurante,Barrio):-
    restaurante(Restaurante,Estrellas,Barrio),
    Estrellas > EstrellasNecesarias.

% 2) Cuáles son los restaurantes sin estrellas.
restauranteSinEstrella(Restaurante):-
    restaurante(Restaurante,_,_),
    not(restauranteDeMasDeNEstrellas(0,Restaurante,_)).

% 3) Si un restaurante está mal organizado, que es cuando tiene algún menú que tiene más pasos que la cantidad de vinos disponibles o cuando tiene en su menú a la carta dos veces una misma comida con diferente precio.

restauranteMalOrganizado(Restaurante):-
    menu(Restaurante, pasos(CantidadDePasos,_,ListaDeVinos,_)),
    cantidadDeVinos(ListaDeVinos, CantidadDeVinosDisponibles),
    CantidadDePasos > CantidadDeVinosDisponibles.

cantidadDeVinos(ListaDeVinos,CantidadDeVinos):-
    length(ListaDeVinos, CantidadDeVinos).

restauranteMalOrganizado(Restaurante):-
    restaurante(Restaurante,_,_),
    tieneDosMismosPlatosConDiferentePrecio(Restaurante).
    
tieneDosMismosPlatosConDiferentePrecio(Restaurante):-
    menu(Restaurante, carta(Precio, Plato)),
    menu(Restaurante, carta(OtroPrecio, Plato)),
    Precio \= OtroPrecio.

% 4) Qué restaurante es copia barata de qué otro restaurante, lo que sucede cuando el primero tiene todos los platos a la carta que ofrece el
%  otro restaurante, pero a un precio menor. Además, no puede tener más estrellas que el otro. 

esCopiaBarataDe(Restaurante,RestauranteCopia):-
    restaurante(Restaurante,_,_),
    restaurante(RestauranteCopia,_,_),
    Restaurante \= RestauranteCopia, % si no pones esto machea con si mismo
    forall( (menu(Restaurante,carta(PreciosMayores,Platos)), 
    Restaurante \= RestauranteCopia),
    ( menu(RestauranteCopia,carta(PreciosMenores,Platos)), 
    PreciosMenores < PreciosMayores) ).
    
% 5)

precioDeUnMenu(Restaurante,Precio):-
    menu(Restaurante, carta(Precio,_)).

precioPromedioDeUnMenu(Restaurante,PrecioPromedio):-
    restaurante(Restaurante,_,_),
    findall(PreciosMenues, precioDeUnMenu(Restaurante,PreciosMenues), ListaPrecios),
    sum_list(ListaPrecios,Precios),
    length(ListaPrecios , CantidadDeMenues),
    CantidadDeMenues > 0,
    PrecioPromedio is Precios / CantidadDeMenues.

precioDeUnMenu(Restaurante,PrecioMenu):-
    menu(Restaurante, pasos(_,Precio, ListaDeVinos, Comensales)),
    precioDeLosVinos(ListaDeVinos, PrecioVinos),
    PrecioMenu is (Precio + PrecioVinos) / Comensales.

precioDeLosVinos(ListaDeVinos,PrecioVinos):-
    findall(Precio, ( member(Vinos, ListaDeVinos),precioDeUnVino(Vinos,Precio) ), ListaPrecioVinos),
    sum_list(ListaPrecioVinos, PrecioVinos).

precioDeUnVino(Vino,Precio):-
    vino(Vino,argentina,Precio).

precioDeUnVino(Vino,Precio):-
    vino(Vino,Pais,PrecioPublicado),
    Pais \= argentina,
    sumarTasaAduanera(PrecioPublicado,Precio).

sumarTasaAduanera(PrecioPublicado,Precio):-
    porcentaje( 35, PrecioPublicado, Porcentaje),
    Precio is PrecioPublicado + Porcentaje.

porcentaje(Numero,PrecioPublicado, Porcentaje):-
    Porcentaje is PrecioPublicado * (Numero / 100). 