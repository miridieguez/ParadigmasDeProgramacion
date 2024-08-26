{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Redundant flip" #-}
{-# HLINT ignore "Use section" #-}
module Library where

import PdePreludat
import Data.Foldable (find)

------------------------------------------------------------------
---------------------MODELO INICIAL-------------------------------
------------------------------------------------------------------


data Idioma = Ingles | Frances | Aleman | Catalan | Español | Melmacquiano  deriving (Eq,Show)

data Turista = UnTurista{
    cansansio :: Number,
    viajaSolo :: Bool,
    stress :: Number,
    idiomas :: [Idioma]
} deriving (Eq,Show)


--ojo como hacer un porcentaje, que yo no se
{-cambiarStressPorcentual porciento turista =
  cambiarStress (div (porciento * stress turista) 100) turista-}

reduccionCansansioPorPlayaSolo = 5
reduccionStressPorPlayaAcompaniado = 1

type Excursion = Turista -> Turista

playa :: Excursion
--aca mejor usar guardas
playa (UnTurista cansansio True stress idiomas) = UnTurista ( cansansio - reduccionCansansioPorPlayaSolo ) True stress idiomas
playa (UnTurista cansansio False stress idiomas) = UnTurista cansansio False ( stress - reduccionStressPorPlayaAcompaniado ) idiomas

apreciarPaisaje :: String -> Excursion
apreciarPaisaje apreciado turista = turista {stress= stress turista - length apreciado}

salirAHablar :: Idioma -> Excursion
salirAHablar idioma turista =  turista {idiomas= idioma : idiomas turista, viajaSolo = False}

cadaCuantoTiempoAumentaLaIntensidad = 4

nivelDeIntensidad :: Number -> Number
nivelDeIntensidad tiempo = tiempo / cadaCuantoTiempoAumentaLaIntensidad

caminar :: Number -> Excursion
caminar minutos turista =
    turista {stress= stress turista - nivelDeIntensidad minutos, cansansio = cansansio turista + nivelDeIntensidad minutos}

data Marea = Fuerte | Moderada | Tranquila deriving(Show,Eq)

aumentoPormareaFuerte = (6,10)

paseoEnBarco :: Marea -> Excursion
paseoEnBarco Fuerte turista = turista {stress= stress turista + snd aumentoPormareaFuerte, cansansio = cansansio turista + fst aumentoPormareaFuerte}
paseoEnBarco Moderada turista = turista --se puede poner id en vez de turista, del lado derecho del =
paseoEnBarco Tranquila turista = (caminar 10 . apreciarPaisaje "mar" . salirAHablar Aleman) turista



------------------PUNTO 1----------------
ana = UnTurista{
    cansansio = 0,
    viajaSolo = False,
    stress = 21,
    idiomas = [Español]
}
beto = UnTurista{
    cansansio = 15,
    viajaSolo = True,
    stress = 15,
    idiomas = [Aleman]
}
cathi = UnTurista{
    cansansio = 15,
    viajaSolo = True,
    stress = 15,
    idiomas = [Aleman,Catalan]
}



------------------PUNTO 2----------------

------------------parte A----------------
{-Hacer que un turista haga una excursión. 
Al hacer una excursión, el turista además de sufrir los efectos propios de la excursión, reduce en un 10% su stress.-} 


hacerExcursion :: Excursion -> Turista -> Turista
hacerExcursion excursion =
    reducirStressPorcentaje 10 . excursion


reducirStressPorcentaje :: Number -> Turista -> Turista
reducirStressPorcentaje porcentaje turista =
     turista {stress = stress turista - (stress turista * (porcentaje/100)) }

{-podrias usar la funcion definida arriba
hacerExcursion excursion = cambiarStressPorcentual (-10) . excursion
-}

------------------parte B----------------
{-Definir la función deltaExcursionSegun que a partir de un índice, un turista y una excursión determine cuánto varió dicho índice 
después de que el turista haya hecho la excursión. Llamamos índice a cualquier función que devuelva un número a partir de un turista.-}

deltaSegun :: (a -> Number) -> a -> a -> Number
deltaSegun f algo1 algo2 = f algo1 - f algo2

--                     indice a comparar                   excursion
deltaExcursionSegun :: (Turista->Number) -> Turista -> Excursion -> Number
deltaExcursionSegun indice turista excursion =
    deltaSegun indice turista (hacerExcursion excursion turista)

------------------parte C----------------
-- i. Saber si una excursión es educativa para un turista, que implica que termina aprendiendo algún idioma.

esEducativa :: Excursion -> Turista -> Bool
esEducativa excursion turista =
    deltaSegun length (idiomas turista) (idiomas (hacerExcursion excursion turista)) /= 0

--aca era mas facil usar la otra delta
{-
esDesestresante turista = (<= -3) . deltaExcursionSegun stress turista
-}

--  ii. Conocer las excursiones desestresantes para un turista. Estas son aquellas que le reducen al menos 3 unidades de stress al turista.

excursionesDesestresantes :: Turista ->[Excursion] -> [Excursion]
excursionesDesestresantes  turista excursiones = filter (esDesestresante turista) excursiones

esDesestresante :: Turista -> Excursion -> Bool
esDesestresante turista excursion =
    deltaExcursionSegun stress turista excursion >= indiceDesestres

indiceDesestres = 3

--otra opcion hecha por mi
{-esDesestresante :: Turista -> (Turista->Turista) -> Bool
esDesestresante turista excursion =
     (stress (hacerExcursion excursion turista) - stress turista ) > 3 
     -}


------------------PUNTO 3----------------

type Tour = [Excursion]

completo :: Tour
completo = [caminar 20, apreciarPaisaje "cascada", caminar 40, playa, salirAHablar Melmacquiano]

--ESTO ES IMPORTANTE, SABER QUE SI TE AGREGAN PARAMETROS QUE NO PODES INCLUIR, PODES HACER FUNCIONES QUE INCLUYEN LOS DATA O TYPES QUE NECESITAS
ladoB :: Excursion -> Tour
ladoB excursion= [paseoEnBarco Tranquila, excursion, caminar 120]

--IDEM
islaVecina :: Marea -> Tour
islaVecina marea
    | marea == Fuerte = [paseoEnBarco marea, apreciarPaisaje "lago", paseoEnBarco marea]
    | otherwise = [paseoEnBarco marea, playa, paseoEnBarco marea]
--aca en la resolucion hacen subfunciones para excursion en isla vecina y ahi ponen o playa o apreciar lago

------------------parte A----------------
{-Hacer que un turista haga un tour. Esto implica, 
primero un aumento del stress en tantas unidades como cantidad de excursiones tenga el tour, y luego realizar las excursiones en orden.-}

hacerTour :: Tour -> Turista -> Turista
hacerTour tour turista = (hacerExcursiones tour . aumentoStress tour) turista

aumentoStress :: Tour -> Turista -> Turista
aumentoStress tour turista = turista { stress = stress turista + length tour }

--foldr desde la derecha y foldl desde la izquierda (lo que necesitamos).
        --lista de funciones (t->t)
hacerExcursiones :: Tour -> Turista -> Turista
hacerExcursiones tour turista = foldl (flip hacerExcursion) turista tour

--Aca si no fuese necesario hacerlas en orden:
--hacerExcursiones tour turista = foldr hacerExcursion turista tour

------------------parte B----------------
{-Dado un conjunto de tours, saber si existe alguno que sea convincente para un turista. 
Esto significa que el tour tiene alguna excursión desestresante la cual, además, deja al turista acompañado luego de realizarla.-}

algunTourConvincente :: Turista -> [Tour] -> Bool
algunTourConvincente turista tours = any (flip esConvincente turista) tours

esConvincente :: Tour -> Turista -> Bool
esConvincente tour turista = ( any (entregaAcompaniante turista) .  excursionesDesestresantes turista ) tour

entregaAcompaniante ::  Turista -> Excursion -> Bool
entregaAcompaniante turista excursion = (estaAcompaniado . flip hacerExcursion turista) excursion

estaAcompaniado :: Turista -> Bool
estaAcompaniado turista = not (viajaSolo turista)

------------------parte C----------------
{-Saber la efectividad de un tour para un conjunto de turistas. Esto se calcula como la sumatoria de la espiritualidad
 recibida de cada turista a quienes les resultó convincente el tour. 
La espiritualidad que recibe un turista es la suma de las pérdidas de stress y cansancio tras el tour.-}

efectividadDelTour :: Tour -> [Turista] -> Number
efectividadDelTour tour turistas = (sum . map (espiritualidadRecibida tour) . filter (esConvincente tour) ) turistas

espiritualidadRecibida :: Tour -> Turista -> Number
espiritualidadRecibida tour turista = deltaTourSegun stress turista tour - deltaTourSegun cansansio turista tour 

deltaTourSegun :: (Turista->Number) -> Turista -> Tour -> Number
deltaTourSegun indice turista tour =
    deltaSegun indice turista (hacerTour tour turista)

------------------PUNTO 4----------------

------------------parte A----------------
infinitasPlayas :: Tour
infinitasPlayas = repeat playa

--playasEternas = salidaLocal : repeat playa

------------------parte B----------------

-- ¿Se puede saber si ese tour es convincente para Ana? ¿Y con Beto? Justificar.

--Es convincente un tour si tiene alguna excursión desestresante la cual, además, deja al turista acompañado luego de realizarla.
{-ana = UnTurista{
    cansansio = 0,
    viajaSolo = False,
    stress = 21,
    idiomas = [Español]
}
beto = UnTurista{
    cansansio = 15,
    viajaSolo = True,
    stress = 15,
    idiomas = [Aleman]
}
playa (UnTurista cansansio True stress idiomas) = UnTurista ( cansansio - reduccionCansansioPorPlayaSolo ) True stress idiomas
playa (UnTurista cansansio False stress idiomas) = UnTurista cansansio False ( stress - reduccionStressPorPlayaAcompaniado ) idiomas

Respuesta: no se puede saber si un tour es convincente porque:
    - caso ANA: si la persona esta acompañada, la excursion playa es desestresante y ya está acompañada. Así que se puede evaluar.
    - caso BETO: la playa no es desetresante entonces se va a quedar infinitamente buscando alguna excursion que cumpla las condiciones. 
    (EL ALGORITMO DIVERGE)

------------------parte C----------------
¿Existe algún caso donde se pueda conocer la efectividad de este tour? Justificar.

No porque no se puede calcular la espiritualidad que recibe un turista, ya que para eso necesitariamos valores que se calculan despues de
que un turista termine el tour

RTA: Solamente funciona para el caso que se consulte con una lista vacía de turista, que dará siempre 0.
-}
