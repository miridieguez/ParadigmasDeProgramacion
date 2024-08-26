{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use infix" #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Use newtype instead of data" #-}
{-# HLINT ignore "Avoid lambda using `infix`" #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
{-# HLINT ignore "Use section" #-}
module Library where
import PdePreludat
import GHC.Base (Opaque(O))


data Jugador = UnJugador {
  nombre :: String,
  padre :: String,
  habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
  fuerzaJugador :: Number,
  precisionJugador :: Number
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro {
  velocidad :: Number,
  precision :: Number,
  altura :: Number
} deriving (Eq, Show)

-- Funciones útiles
between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)
mayorSegun f a b
  | f a > f b = a
  | otherwise = b


--RESOLUCION

type Puntos = Number
type N = Number

data Palo = Putter | Madera | Hierro N  deriving(Eq,Show)

tirar :: Palo -> Habilidad -> Tiro
tirar Putter habilidad = UnTiro {velocidad=10, precision = precisionJugador habilidad *2, altura=0}
tirar Madera habilidad = UnTiro {velocidad=100, precision = precisionJugador habilidad /2, altura=5}
tirar (Hierro numero) habilidad = UnTiro {velocidad= fuerzaJugador habilidad *numero, precision= precisionJugador habilidad /numero, altura= numero-3 `max` 0}

palos :: [Palo]
palos = [Putter, Madera] ++ map Hierro [1..10] --OJO

golpe:: Jugador -> Palo -> Tiro
golpe jugador palo= tirar palo (habilidad jugador)

data Obstaculo = Obstaculo {
    requisitos :: [Tiro->Bool],
    largo :: Number
} deriving (Eq,Show)

estaEntre :: Number -> Number -> String -> Tiro -> Bool
estaEntre max min criterio tiro
    | criterio == "precision" = precision tiro > min && precision tiro < max
    | criterio == "velocidad" = velocidad tiro > min && velocidad tiro < max
    | criterio == "altura" = altura tiro > min && altura tiro < max

esMayor:: Number -> String -> Tiro -> Bool
esMayor max criterio tiro
    | criterio == "precision" = precision tiro > max
    | criterio == "velocidad" = velocidad tiro > max
    | criterio == "altura" = altura tiro > max

vaAlRasdelSuelo:: Tiro -> Bool
vaAlRasdelSuelo unTiro = altura unTiro == 0
tunelRampita = Obstaculo {
    requisitos= [(esMayor 90 "precision"),(vaAlRasdelSuelo)],
    largo = 0
    }

laguna= Obstaculo{
    requisitos= [(esMayor 80 "velocidad"),(estaEntre 1 5 "altura")],
    largo = 0
    }

hoyo= Obstaculo{
    requisitos= [(estaEntre 5 20 "velocidad"),(esMayor 95 "precision"),(estaEntre 0 0 "altura")],
    largo = 0
    }

superarObstaculo :: Tiro -> Obstaculo -> Tiro
superarObstaculo tiro obstaculo 
    | all (\requisitos -> requisitos tiro) (requisitos obstaculo) = modificarTiro tiro obstaculo
    | otherwise = tiroDetenido

modificarTiro :: Tiro -> Obstaculo -> Tiro
modificarTiro tiro tunelRampita = tiro {velocidad=velocidad tiro*2, precision=100, altura=0}
modificarTiro tiro laguna = tiro {altura=altura tiro/largo laguna}
modificarTiro tiro hoyo = tiroDetenido

superaObstaculo :: Obstaculo -> Tiro -> Bool
superaObstaculo obstaculo tiro = 
  altura (superarObstaculo tiro obstaculo) /= 0 || precision (superarObstaculo tiro obstaculo) /= 0 || velocidad (superarObstaculo tiro obstaculo) /= 0

tiroDetenido :: Tiro          --OJO
tiroDetenido = UnTiro 0 0 0 


--EJ 4
--------------parte A-------------
palosUtiles :: [Palo] -> Jugador -> Obstaculo -> [Palo]
palosUtiles palos jugador obstaculo =
  filter (superaObstaculo obstaculo . golpe jugador) (palos)

--------------parte B-------------
--este sin recursividad era muy dificil por el tema de los efectos, igual lo dejo aca
{-
cuantosObstaculosConsecutivosSupera' :: Tiro -> [Obstaculo] -> Number
cuantosObstaculosConsecutivosSupera' tiro obstaculos
  = (length . takeWhile (\(obstaculo, tiroQueLeLlega) -> superaObstaculo obstaculo tiroQueLeLlega)
      . zip obstaculos . tirosSucesivos tiro) obstaculos

tirosSucesivos :: Tiro -> [Obstaculo] -> [Tiro]
tirosSucesivos tiroOriginal obstaculos
  = foldl (\tirosGenerados obstaculo ->
         tirosGenerados ++
           [superarObstaculo obstaculo (last tirosGenerados)]
      ) [tiroOriginal] obstaculos -}

 --este con recu

cuantosObstaculosConsecutivosSupera ::  [Obstaculo] -> Tiro -> Number
cuantosObstaculosConsecutivosSupera  [] tiro = 0
cuantosObstaculosConsecutivosSupera  (obstaculo : obstaculos) tiro
  | superaObstaculo obstaculo tiro
      = 1 + cuantosObstaculosConsecutivosSupera obstaculos (superarObstaculo tiro obstaculo) 
  | otherwise = 0

--------------parte C-------------
paloMasUtil :: Jugador -> [Obstaculo] -> [Palo] -> Palo
paloMasUtil jugador obstaculos palos =
  foldl1 (elMejorEntre jugador obstaculos) palos 


elMejorEntre :: Jugador -> [Obstaculo] -> Palo -> Palo -> Palo
elMejorEntre jugador obstaculos palo1 palo2
    | esMejor jugador obstaculos palo1 palo2 = palo1
    | otherwise = palo2

esMejor :: Jugador -> [Obstaculo] -> Palo -> Palo -> Bool
esMejor jugador obstaculos palo1 palo2 = 
  cuantosObstaculosConsecutivosSupera obstaculos (golpe jugador palo1) >  cuantosObstaculosConsecutivosSupera obstaculos (golpe jugador palo2)  

{-
--EJ 4
palosUtiles :: Jugador -> Obstaculo -> palos -> [Palo]
palosUtiles jugador obstaculo palosPosibles = filter (esUtil jugador obstaculo) palos

esUtil:: Jugador -> Obstaculo -> Palo -> Bool
esUtil jugador obstaculo palo = superaObstaculo (golpe jugador palo) obstaculo

--Saber, a partir de un conjunto de obstáculos y un tiro, cuántos obstáculos consecutivos se pueden superar.

cuantosObstaculosSupera :: [Obstaculo] -> Tiro -> Number
cuantosObstaculosSupera [] _ = 0
cuantosObstaculosSupera (x:xs) tiro
    |superaObstaculo tiro x = 1+ cuantosObstaculosSupera xs (superarObstaculo tiro x)
    |otherwise=0


--cuantosObstaculosSupera obstaculos tiro =(length . filter(tiroNoDetenido) . map (superarObstaculo tiro)) obstaculos

tiroNoDetenido :: Tiro -> Bool
tiroNoDetenido tiro = altura tiro /=0 && precision tiro /=0 && velocidad tiro /=0 

--Definir paloMasUtil que recibe una persona y una lista de obstáculos y determina cuál es el palo que le permite superar 
--más obstáculos con un solo tiro.

paloMasUtil::[Obstaculo] -> Jugador -> Palo
paloMasUtil obstaculos jugador = maximoSegun (cuantosObstaculosSupera obstaculos . golpe jugador) palos
--                                esta funcion espera un tiro y retorna un number, esta espera un palo y devuelve un tiro
--                                 entonces toda la funcion completa nos queda q recibe palo y devuelve number,que es lo q nos sirve para foldr

--DATO SI DICE FOLDABLE, DESPUES LO QUE ESTA CON UNA T ADELANTE ES UNA LISTA

--Dada una lista de tipo [(Jugador, Puntos)] que tiene la información de cuántos puntos ganó cada niño al finalizar el torneo,
-- se pide retornar la lista de padres que pierden la apuesta por ser el “padre del niño que no ganó”.
-- Se dice que un niño ganó el torneo si tiene más puntos que los otros niños.
jugadorTorneo= fst --OJO
puntosObtenidos = snd

padresPerdedores :: [(Jugador,Number)] -> [String]
padresPerdedores tupla = (map devolverPadre . filter (esPerdedor tupla)) tupla

devolverPadre:: (Jugador,Number) -> String
devolverPadre tupla = (padre . jugadorTorneo) tupla

esPerdedor:: [(Jugador,Number)] -> (Jugador,Number) -> Bool
esPerdedor tupla jugador = jugador/= jugadorGanador tupla

jugadorGanador:: [(Jugador,Number)] -> (Jugador,Number)
jugadorGanador tupla = maximoSegun puntosObtenidos tupla


{-ALTERNATIVA
data Obstaculo = UnObstaculo {
  puedeSuperar :: Tiro -> Bool,
  efectoLuegoDeSuperar :: Tiro -> Tiro
  }
intentarSuperarObstaculo :: Obstaculo -> Tiro -> Tiro
intentarSuperarObstaculo obstaculo tiroOriginal
  | (puedeSuperar obstaculo) tiroOriginal = (efectoLuegoDeSuperar obstaculo) tiroOriginal
  | otherwise = tiroDetenido
{-
Un túnel con rampita sólo es superado si la precisión es mayor a 90 yendo al ras del suelo, independientemente de la velocidad del tiro. Al salir del túnel la velocidad del tiro se duplica, la precisión pasa a ser 100 y la altura 0.
-}
tunelConRampita :: Obstaculo
tunelConRampita = UnObstaculo superaTunelConRampita efectoTunelConRampita

tiroDetenido = UnTiro 0 0 0

superaTunelConRampita :: Tiro -> Bool
superaTunelConRampita tiro = precision tiro > 90 && vaAlRasDelSuelo tiro

vaAlRasDelSuelo = (== 0).altura

efectoTunelConRampita :: Tiro -> Tiro
efectoTunelConRampita tiroOriginal = UnTiro {
  velocidad = velocidad tiroOriginal *2,
  precision = 100,
  altura = 0 }
{-
Una laguna es superada si la velocidad del tiro es mayor a 80 y tiene una altura de entre 1 y 5 metros. Luego de superar una laguna el tiro llega con la misma velocidad y precisión, pero una altura equivalente a la altura original dividida por el largo de la laguna.
-}
laguna :: Int -> Obstaculo
laguna largo = UnObstaculo superaLaguna (efectoLaguna largo)

superaLaguna :: Tiro -> Bool
superaLaguna tiro = velocidad tiro > 80 && (between 1 5 . altura) tiro
efectoLaguna :: Int -> Tiro -> Tiro
efectoLaguna largo tiroOriginal = tiroOriginal {
    altura = altura tiroOriginal `div` largo
  }
{-
Un hoyo se supera si la velocidad del tiro está entre 5 y 20 m/s yendo al ras del suelo con una precisión mayor a 95. Al superar el hoyo, el tiro se detiene, quedando con todos sus componentes en 0.
-}

--hoyo :: Obstaculo
--hoyo = UnObstaculo superaHoyo efectoHoyo

--superaHoyo :: Tiro -> Bool
--superaHoyo tiro = (between 5 20 . velocidad) tiro && vaAlRasDelSuelo tiro && precision tiro > 95
--efectoHoyo :: Tiro -> Tiro
efectoHoyo _ = tiroDetenido
-}

-}