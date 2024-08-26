{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Use infix" #-}
module Library where
import PdePreludat

data Animal = Animal {
    energia :: Number,
    tipo :: Tipo,
    peso :: Number
} deriving(Show, Eq)

data Tipo = Volador | Terrestre | Acuatico deriving(Show, Eq)

tigre :: Animal
tigre = Animal 5 Terrestre 120

lechuza :: Animal
lechuza = Animal 40 Volador 10

tiburon :: Animal
tiburon = Animal 100 Acuatico 100

-- Parte 1: Animales

--FUNCIONES CREADAS POR MI PARA HACER EL TRABAJO

-- **esDeTipo**: recibe un tipo y un animal y nos devuelve true si es de ese tipo y false si no lo es. 
esDeTipo :: Tipo -> Animal -> Bool
esDeTipo unTipo unAnimal = tipo unAnimal == unTipo
-- **tieneHambre**: recibe un animal y nos devuelve si tiene hambre o no. 
tieneHambre :: Animal -> Bool
tieneHambre unAnimal = energia unAnimal < 10
-- **alimentos**: recibe un alimento y un animal y lo alimenta
alimentos :: String -> Animal -> Animal
alimentos unAlimento unAnimal
     | unAlimento == "baya" = unAnimal {peso = peso unAnimal + 0.1,  energia = energia unAnimal + 5}
     | unAlimento == "carne" = unAnimal {peso = peso unAnimal + 2,  energia = energia unAnimal + 20}
     | otherwise = unAnimal


--FUNCIONES DE LA CONSIGNA

-- **losDeTipo**: recibe un tipo y una lista de animales y nos devuelve aquellos que son de ese tipo.
losDeTipo :: Tipo -> [Animal] -> [Animal]
losDeTipo unTipo listaDeAnimales = filter (esDeTipo unTipo) listaDeAnimales


-- **animalesHambrientos**: dada una lista de animales, nos devuelve solo aquellos que tienen hambre. Que un animal tenga hambre significa que su energía es menor a 10.
animalesHambrientos :: [Animal] -> [Animal]
animalesHambrientos listaDeAnimales = filter tieneHambre listaDeAnimales

-- **entrenar**:
entrenar :: Animal -> Animal
entrenar unAnimal
     | tipo unAnimal == Terrestre = unAnimal {peso = peso unAnimal - 5,  energia = energia unAnimal - 5}
     | tipo unAnimal == Volador = unAnimal {peso = peso unAnimal - 3}
     | otherwise = unAnimal

-- Parte 2: Alimentos y entrenamientos

-- implementar estos alimentos:
-- bayas aumenta la energia en 5 y el peso en 0.1
-- carne aumenta la energia en 20 y el peso en 2

-- **alimentarATodos**: Recibe un alimento y una lista de animales y los alimenta a todos. 
alimentarATodos :: String -> [Animal] -> [Animal]
alimentarATodos unAlimento listaDeAnimales = map (alimentos unAlimento) listaDeAnimales


-- **aplicarItinerario** : Dado un animal y una lista de alimentos y entrenamietos 
--se los aplica a todos en orden (haciendo que el animal sufra todos los efectos).

aplicarItinerario :: [String] -> Animal -> Animal
aplicarItinerario [] unAnimal = unAnimal
aplicarItinerario (x:xs) unAnimal
     | x == "baya" || x == "carne" = aplicarItinerario xs (alimentos x unAnimal)
     | x == "entrenar" = aplicarItinerario xs (entrenar unAnimal)
     | otherwise = aplicarItinerario xs unAnimal


--alimentos :: String -> Animal -> Animal
--entrenar :: Animal -> Animal
entrenarModificada :: String -> Animal -> Animal
entrenarModificada _ unAnimal
     | tipo unAnimal == Terrestre = unAnimal {peso = peso unAnimal - 5 ,  energia = energia unAnimal - 5 }
     | tipo unAnimal == Volador = unAnimal {peso = peso unAnimal - 3 }
     | otherwise = unAnimal



-- Parte 3: Nuestras propias funciones de orden superior

doble :: Number -> Number
doble x = x * 2 --funcion agregada por mi para probar cosas

--- **mapTupla**: recibe una función y una tupla de dos elementos del mismo tipo, 
--y devuelve una tupla con los resultados de aplicar la función a cada valor:
mapTupla :: (a -> b) -> (a , a) -> (b, b)
mapTupla unaFuncion (pri, seg) = (unaFuncion pri, unaFuncion seg)


--- **menorSegun**: recibe una función y dos valores del mismo tipo. 
--menorSegun devuelve aquel valor cuyo resultado al ser aplicado a la función es menor
menorSegun unaFuncion pri seg
     | unaFuncion pri <= unaFuncion seg = pri
     | otherwise = seg

-- **minimoSegun**: dada una lista y una función, devuelve el menor de toda la lista según la función que se pasó. Por ej:
minimoSegun :: Ord a1 => (a2 -> a1) -> [a2] -> a2
minimoSegun unaFuncion (x:xs) = foldr1 (menorSegun unaFuncion) (x:xs)
--OJO forma de usar foldr1


-- **aplicarVeces**: dada un número de veces a aplicar, una funcion y un valor. Aplica el valor como parametro a la funcion 
--tantas veces como dice el número.
aplicarVeces :: Number -> (a -> a) -> a -> a
aplicarVeces veces unaFuncion valor
     | veces == 1 = unaFuncion valor
     | otherwise = unaFuncion (aplicarVeces (veces-1) unaFuncion valor)

-- **replicar**: dado un numero y un valor, devuelve una lista con el valor dentro tantas veces como dice el número. Por ej:
replicar :: Number -> a -> [a]
replicar 0 valor = []
replicar cantidad valor
     | cantidad == 1 = [valor]
     | otherwise = valor : replicar (cantidad-1) valor


-- Parte 4. Bonus: combinando funciones

valor |> funcion = funcion valor

esVocal caracter = elem caracter ['a','e','i','o','u','A','E','I','O','U']

saltoDeLinea :: Char
saltoDeLinea = '\n'

primeraLinea oracion = takeWhile (/= saltoDeLinea) oracion
--primeraLinea oracion = takeWhile (\caracter-> caracter /= saltoDeLinea) oracion


--- **lasVocales**: dado un string, me devuelve otro string con las vocales del primero en orden. Ejemplo:

lasVocales oracion = filter esVocal oracion

-- definir usando |> para combinar las funciones
-- **contarVocalesDeLaPrimerLinea**: dado un string, me devuelve la cantidad de vocales que se encuentran en la primer linea.
--contarVocalesDeLaPrimeraLinea oracion = (length . lasVocales) oracion 
contarVocalesDeLaPrimeraLinea oracion = ( (oracion |> primeraLinea) |> lasVocales ) |> length