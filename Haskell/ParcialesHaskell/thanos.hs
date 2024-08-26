{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use newtype instead of data" #-}
{-# HLINT ignore "Use section" #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Redundant bracket" #-}
module Library where
import PdePreludat

-------MODELO MIO PARA PROBAR COSITAS-------
mundoMagico = UnUniverso {habitantes = [caro,miri,pablo]}

miri = UnPersonaje {
    nombre = "Miranda",
    edad = 18,
    energia = 6,
    habilidades = ["llorar", "buena hija", "buena hermana"],
    planeta = "Venus"
}
pablo = UnPersonaje {
    nombre = "Pablo",
    edad = 50,
    energia = 20,
    habilidades = ["super papa"],
    planeta = "Venus"
}
caro = UnPersonaje {
    nombre = "Mama",
    edad = 68,
    energia = 20,
    habilidades = ["super mama", "empatica", "companiera de vida"],
    planeta = "Venus"
}


-----------------------------------------------
---------------PRIMERA PARTE-------------------
-----------------------------------------------

-------------------PUNTO 1---------------------


data Personaje = UnPersonaje {
    nombre :: String,
    edad :: Number,
    energia :: Number,
    habilidades :: [String],
    planeta :: String
} deriving (Show,Eq)

data Guantelete = UnGuantelete {
    material :: String,
    gemas :: [Gema]
}

data Universo = UnUniverso { habitantes :: [Personaje] }


chasquido :: Guantelete -> Universo -> Universo
chasquido guantelete universo
    | guanteleteValidoParaChasquido guantelete = universo { habitantes = (eliminarDeListaALosPrimeros universo . cantidadAEliminar) universo }
    | otherwise = universo

guanteleteValidoParaChasquido :: Guantelete -> Bool
guanteleteValidoParaChasquido guantelete = material guantelete == "uru" && length (gemas guantelete) == 6

cantidadAEliminar :: Universo -> Number
cantidadAEliminar universo =
     length (habitantes universo) / 2

eliminarDeListaALosPrimeros :: Universo -> Number -> [Personaje]
eliminarDeListaALosPrimeros universo numero =
    take numero (habitantes universo)

--reducirMitad :: Universo -> Universo
--reducirMitad universo = take (length universo `div` 2) universo     

------------------PUNTO 2----------------
{-Saber si un universo es apto para péndex, que ocurre si alguno de los personajes
que lo integran tienen menos de 45 años-}

esAptoParaPendex :: Universo -> Bool
esAptoParaPendex universo = any (tieneMenosDe aniosPendex) (habitantes universo)

tieneMenosDe :: Number -> Personaje -> Bool
tieneMenosDe anios personaje = edad personaje < anios

aniosPendex = 45

{- Saber la energía total de un universo que es la sumatoria de todas las energías de
sus integrantes que tienen más de una habilidad-}
energiaTotal :: Universo -> Number
energiaTotal universo = ( sum . map energia . filter tieneMasDeUnaHabilidad ) (habitantes universo)

tieneMasDeUnaHabilidad :: Personaje -> Bool
tieneMasDeUnaHabilidad personaje = length (habilidades personaje) > 1

--como esta resuelto por ellos
{-universoAptoParaPendex :: Universo -> Bool 
universoAptoParaPendex = any $ (<=45).edad

energiaTotalDelUniverso :: Universo -> Float 
energiaTotalDelUniverso = sum.map energia.filter ((>1).length.habilidades)-}

-----------------------------------------------
---------------SEGUNDA PARTE-------------------
-----------------------------------------------

type Gema = [Personaje->Personaje]

mente :: Number -> Gema
mente valor = [debilitarEnergia valor]

debilitarEnergia :: Number -> Personaje -> Personaje
debilitarEnergia valor personaje = personaje {energia = energia personaje - valor}

alma :: String -> Gema
alma habilidadAEliminar = [eliminarHabilidad habilidadAEliminar, debilitarEnergia 10]

eliminarHabilidad :: String -> Personaje -> Personaje
eliminarHabilidad habilidadAEliminar personaje = personaje {habilidades = filter (/= habilidadAEliminar) (habilidades personaje)}

espacio :: String -> Gema
espacio planeta = [mandarA planeta , debilitarEnergia 20]

mandarA :: String -> Personaje -> Personaje
mandarA planeta personaje = personaje {planeta = planeta}

poder :: Gema
poder = [matar , quitarHabilidades ]

matar :: Personaje -> Personaje
matar personaje = debilitarEnergia (energia personaje) personaje

quitarHabilidades :: Personaje -> Personaje
quitarHabilidades personaje
    | length (habilidades personaje) <= 2 = personaje { habilidades = [] }
    | otherwise = personaje

tiempo :: Gema
tiempo = [reducirEdad , debilitarEnergia 50]

reducirEdad :: Personaje -> Personaje
reducirEdad personaje
    | edad personaje <= 18 = personaje
    | edad personaje > 18 && edad personaje <= 36 = personaje {edad = 18}
    | otherwise = personaje {edad = edad personaje / 2 }

{-tiempo :: Gema
tiempo personaje = quitarEnergia 50 personaje {
  edad = (max 18.div (edad personaje)) 2 -}


laGemaLoca :: Gema -> Gema
laGemaLoca gemaContraRival = [ aplicarGema gemaContraRival, aplicarGema gemaContraRival ]


------------------PUNTO 3----------------

aplicarGema :: Gema -> Personaje -> Personaje
aplicarGema gema rival = foldr ($) rival gema

------------------PUNTO 4----------------

guanteledeDeEjemplo = UnGuantelete {
    material = "Goma",
    gemas = [tiempo, alma "usar Mjolnir", laGemaLoca (alma "programacion en Haskell")]
}

------------------PUNTO 5----------------

utilizar :: [Gema] -> Personaje -> Personaje
utilizar gemas personaje = foldr aplicarGema personaje gemas

--usar listaDeGemas destinatario = foldr ($) destinatario $ listaDeGemas  

------------------PUNTO 6----------------
gemaMasPoderosas :: Guantelete -> Personaje -> Gema
gemaMasPoderosas (UnGuantelete _ [x]) _  = x
gemaMasPoderosas (UnGuantelete material (x:xs)) personaje
    | energia (aplicarGema x personaje) > energia (aplicarGema (head xs) personaje) =
        gemaMasPoderosas (UnGuantelete material xs) personaje
    | otherwise = gemaMasPoderosas (UnGuantelete material (x:tail xs)) personaje

------------------PUNTO 7----------------
-- Dada la función generadora de gemas y un guantelete de locos:

infinitasGemas :: Gema -> [Gema]
infinitasGemas gema = gema:(infinitasGemas gema)

guanteleteDeLocos :: Guantelete
guanteleteDeLocos = UnGuantelete{
    material = "vesconite",
    gemas = infinitasGemas tiempo
}
--Y la función

usoLasTresPrimerasGemas :: Guantelete -> Personaje -> Personaje
usoLasTresPrimerasGemas guantelete = (utilizar . take 3 . gemas) guantelete

{-Justifique si se puede ejecutar, relacionándolo con conceptos vistos en la cursada:
    -gemaMasPoderosa miri guanteleteDeLocos
    
    No se puede ejecutar porque se utiliza Eager Evaluation, es decir que solo hay un resultado cuando se terminan de analizar
    todas las gemas, porque hay que determinar cual de todas quita mayor energia , y como en este caso son infinitas, resulta imposible
    
    -usoLasTresPrimerasGemas guanteleteDeLocos miri
    Este caso si se puede ejecutar porque si se utiliza lezy evaluation, lo unico que le importa a la funcion es llevarse
    las primeras tres gemas que tenemos, y no es necesario que termine de recorrer toda la lista infinita
-}