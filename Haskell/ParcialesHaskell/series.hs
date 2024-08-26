{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}

module Library where
import PdePreludat
import qualified Control.Applicative as lista

type Restriccion = String

data Actor = UnActor {
    nombreActor :: String,
    sueldoAnual :: Number,
    restricciones :: [Restriccion]
} deriving (Show,Eq)

data Serie =  UnaSerie {
    nombreSerie :: String,
    actores :: [Actor],
    presupuesto :: Number,
    temporadas :: Number,
    ratingPromedio :: Number,
    estaCancelada :: Bool
} deriving (Show,Eq)

paulRudd = UnActor {
    nombreActor = "Paul Rudd",
    sueldoAnual = 36,
    restricciones = ["no actura en bata", "ensalada de rucula todos los dias"]
}

miri = UnActor {
    nombreActor = "miri dieguez",
    sueldoAnual = 30,
    restricciones = ["no actura en bata", "ensalada de rucula todos los dias"]
}

tati = UnActor {
    nombreActor = "tati",
    sueldoAnual = 30,
    restricciones = ["no actura en bata", "ensalada de rucula todos los dias"]
}

pablo = UnActor {
    nombreActor = "pablo",
    sueldoAnual = 30,
    restricciones = [ "ensalada de rucula todos los dias"]
}

caro = UnActor {
    nombreActor = "caro",
    sueldoAnual = 30,
    restricciones = ["no actura en bata"]
}

casaDePapel = UnaSerie {
    nombreSerie ="",
    actores = [paulRudd,miri,tati],
    presupuesto = 67,
    temporadas = 4,
    ratingPromedio = 4,
    estaCancelada = False
}

oitnb = UnaSerie {
    nombreSerie ="",
    actores = [caro],
    presupuesto = 67,
    temporadas = 10,
    ratingPromedio = 4,
    estaCancelada = False
}

vAv = UnaSerie {
    nombreSerie ="",
    actores = [miri],
    presupuesto = 67,
    temporadas = 10,
    ratingPromedio = 4,
    estaCancelada = True
}


-----------PUNTO 1-----------

-----------parte a-----------

estaEnRojoLaSerie :: Serie -> Bool
estaEnRojoLaSerie serie = presupuesto serie < cantidadAPAgarPorActores serie

cantidadAPAgarPorActores :: Serie -> Number
cantidadAPAgarPorActores serie = ( sum . map sueldoAnual ) (actores serie)

-----------parte b-----------

esProblematica :: Serie -> Bool
esProblematica serie = ( (> 3) . length . filter actortieneMasDeUnaRestriccion) (actores serie)

actortieneMasDeUnaRestriccion :: Actor -> Bool
actortieneMasDeUnaRestriccion =  (> 1) . length . restricciones

-----------PUNTO 2-----------

-----------parte a-----------

type Productor = (Serie -> Serie)

conFavoritismos :: Actor -> Actor -> Productor
conFavoritismos actorFavorito1 actorFavorito2 =
    agregarActores actorFavorito1 actorFavorito2 . eliminarPrimerosActores 2

agregarActores :: Actor -> Actor -> Serie -> Serie
agregarActores actor1 actor2 serie =
    serie { actores = actor1:actor2:actores serie }

eliminarPrimerosActores :: Number -> Serie -> Serie
eliminarPrimerosActores cantidadAEliminar serie =
    serie { actores = drop cantidadAEliminar ( actores serie ) }

timBurton :: Productor
timBurton = conFavoritismos johnnyDepp helenaBonham

johnnyDepp = UnActor {
    nombreActor = "Johnny Depp",
    sueldoAnual = 20000000,
    restricciones = []
}

helenaBonham = UnActor {
    nombreActor = "Helena Bonham",
    sueldoAnual = 15000000,
    restricciones = []
}

gatopardeitor :: Productor
gatopardeitor serie = serie

estireitor :: Productor
estireitor serie =
    serie { temporadas = temporadas serie * 2 }

desespereitor :: Productor
desespereitor = gatopardeitor . estireitor

--lo habia hecho mal porque no entendi la consigna
{-desespereitor :: Serie ->  Productor] -> Serie
desespereitor serie Productores = foldr ($) serie Productores-}

canceleitor :: Number -> Productor --OJO APLICACION PARCIAL DE UN TYPE
canceleitor numero serie
    | estaEnRojoLaSerie serie || ( ratingPromedio serie < numero ) = cancelarSerie serie
    | otherwise = serie

cancelarSerie :: Serie -> Serie
cancelarSerie serie = serie { estaCancelada = True }

--el que resolvio el parcial hacia muchos maps, tipo asi 
{-
estireitor :: Productor
estireitor = mapTemporadas (*2)

mapTemporadas :: (Int -> Int) -> Serie -> Serie
mapTemporadas funcion serie = serie { temporadas = funcion (temporadas serie) }
-}

-----------PUNTO 3-----------

bienestarDeUnaSerie :: Serie -> Number
bienestarDeUnaSerie serie
    | estaCancelada serie = 0
    | otherwise = bienestarSegunLongitud serie + bienestarSegunReparto serie

bienestarSegunLongitud :: Serie -> Number
bienestarSegunLongitud serie
    | temporadas serie > 4 = 5
    | otherwise = formulaBienestarPorLongitud (temporadas serie)

formulaBienestarPorLongitud temporadas = ( 10 - temporadas ) * 2


bienestarSegunReparto :: Serie -> Number
bienestarSegunReparto serie
    | length (actores serie) < 10 = 3
    | otherwise =  formulaBienestarPorReparto serie `max` 2


formulaBienestarPorReparto serie = 10 - cantidadDeActoresConRestricciones serie

cantidadDeActoresConRestricciones :: Serie -> Number
cantidadDeActoresConRestricciones serie = (length . filter (/= []) . map restricciones) (actores serie)

-----------PUNTO 4-----------

{-Dada una lista de series y una lista de productores, aplicar para cada serie el
productor que la haga más efectiva: es decir, el que le deja más bienestar.-}

type Series = [Serie]
type Productores = [Productor]

--OJO FUNCION QUE SIRVE MUCHO

producirSerieMasEfectiva :: Series -> Productores -> Series
producirSerieMasEfectiva series productores = map (aplicarProductorMasEfectivo productores) series

aplicarProductorMasEfectivo :: Productores -> Serie -> Serie
aplicarProductorMasEfectivo productores serie =  foldl1 (elMejorEntre serie) productores serie

--recordar que podes esperar a que foldr1 le mande dos productores no 1, para comparar
elMejorEntre :: Serie -> Productor -> Productor -> Productor
elMejorEntre serie productor1 productor2
    | esMejor serie productor1 productor2 = productor1
    | otherwise = productor2

esMejor :: Serie -> Productor -> Productor -> Bool
esMejor serie productor1 productor2 = (bienestarDeUnaSerie . productor1) serie > (bienestarDeUnaSerie . productor2) serie

{- CON RECURSIVIDAD
producirSerieMasEfectiva :: [Serie] -> [Productor] -> [Serie]
producirSerieMasEfectiva series productores = map (masEfectivo productores) series

masEfectivo :: [Productor] -> Serie -> Serie
masEfectivo (x:[]) serie = x serie 
masEfectivo (x:xs) serie
  | bienestarDeUnaSerie (x serie) > bienestarDeUnaSerie (head xs $ serie) = x serie
  | otherwise = masEfectivo xs serie
-}

-----------PUNTO 5-----------

{- OJO ESTO NO SABIA
¿Se puede aplicar el productor gatopardeitor cuando tenemos una lista infinita de actores? 

si, se puede aplicar gatopardeitor con una lista infinita de actores. no se traba en consola.
como la funcion es la funcion id (identidad) devuelve infinitamente la serie que le paso, con la lista infinita de actores.
el problema es que como tiene que mostrar una lista infinita de actores, nunca llego a ver los demas
atributos de la serie (temporadas, rating, etc).
si bien funciona en consola, no cumple con el proposito de la funcion.
-}

{- ¿Y a uno con favoritismos? ¿De qué depende?
En este caso si porque no necesita obtener todos los actores de todas las series, lo unico que hacer es eliminar los primeros dos y 
agregar dos elegidos, en ningun momento se implica ese infinitos actores, con reemplazar los primeros ya esta hecha la "produccion"
 Depende de si agregas los actores al principio o al final
 -}

-----------PUNTO 6-----------
{-
. Saber si una serie es controvertida, que es cuando no se cumple que cada actor de
la lista cobra más que el siguiente. -}

esControvertida :: Serie -> Bool
esControvertida serie = not (cobraMasQueElSiguiente (actores serie) )

cobraMasQueElSiguiente :: [Actor] -> Bool
cobraMasQueElSiguiente [x] = True
cobraMasQueElSiguiente (actor1:actor2:actores)
    | sueldoAnual actor1 < sueldoAnual actor2 = cobraMasQueElSiguiente (actor2:actores)
    | otherwise = False

--SIN RECURSIVIDAD PARA VER SI ESTA ORDENADA, IMPORTANTE

{-esControvertida :: Serie -> Bool
esControvertida serie = not $ cobraMasQueElSiguiente (actores serie)

cobraMasQueElSiguiente :: [Actor] -> Bool
cobraMasQueElSiguiente (x:[]) = True
cobraMasQueElSiguiente (x:xs) = (sueldo x) > (sueldo $ head xs) -}


-----------PUNTO 7-----------
{-Explicar la inferencia del tipo de la siguiente función:

funcionLoca x y = filter (even.x) . map (length.y)

y funcion que recibe una lista (por el map) y devuelve otra lista (por el length), despues length devuelve la longitud de cada lista.
Entonces tenemos una lista de longitudes, numbers. 
A cada number se le aplica x y devuelve un numero, y si es par se queda en la lista si no no (filter) -}

--Ni idea prefiero mostrar la respuesta:

-- primero sabemos que hay dos parametro : x e y
-- como la primer funcion que se va a aplicar es map, sabemos que hay un tercer parametro implicito: z
-- z es una lista, no sabemos de que
-- funcionLoca :: -> -> [a] -> 
-- como y recibe la lista de z, debe tener su mismo tipo, pero puede devolver algo de otro tipo. lo unico que 
-- sabemos de este algo es que debe ser una lista, pues luego se le aplica la funcion length
-- funcionLoca :: -> (a -> [b]) -> [a] -> 
-- luego, se aplica filter. sabemos que el map devuelve una lista de Int y que sobre esa lista se aplicara el filter.
-- por lo que x es una funcion que recibe Int y devuelve un Int (ya que luego se le aplica even)
-- finalmente la funcion funcionLoca devuelve una lista de Int:
-- funcionLoca :: (Int -> Int) -> (a -> [b]) -> [a] -> [Int]


