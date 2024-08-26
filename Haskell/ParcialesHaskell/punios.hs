{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Fuse foldr/map" #-}
module Library where
import PdePreludat

-----------PUNTO 1-----------

-----------parte a-----------

data Peleador = UnPeleador {
    puntosDeVida :: Number,
    resistencia :: Number,
    ataques :: [Ataque]
}


-----------parte b-----------

-- i
estaMuerto :: Peleador -> Bool
estaMuerto peleador = puntosDeVida peleador < 1

-- ii
esHabil :: Peleador -> Bool
esHabil peleador = cantidadDeAtaques peleador > 10

cantidadDeAtaques peleador = length (ataques peleador)

-----------parte c-----------

type Ataque = Peleador -> Peleador
type Intensidad = Number

modificarVidaDelOponente ::  Number -> Peleador -> Peleador
modificarVidaDelOponente numero peleador =
    peleador { puntosDeVida = puntosDeVida peleador + numero }

-- i
golpe :: Intensidad -> Ataque
golpe intensidad peleador =
    modificarVidaDelOponente (formulaReduccionVida intensidad peleador) peleador


formulaReduccionVida :: Number -> Peleador -> Number
formulaReduccionVida intensidad peleador = -(intensidad / resistencia peleador)

-- ii
toqueDeLaMuerte :: Ataque
toqueDeLaMuerte = matarOponente

matarOponente peleador = peleador { puntosDeVida = 0 }

-- iii
data ParteDelCuerpo = Pecho | Carita | Nuca deriving (Eq,Show)

patada :: ParteDelCuerpo -> Ataque
patada parteDelCuerpo peleador
    | parteDelCuerpo == Pecho = patadaMuertoOVivo peleador
    | parteDelCuerpo == Carita = modificarVidaDelOponente (puntosDeVida peleador / (-2)) peleador
    | parteDelCuerpo == Nuca = olvidarPrimerAtaque (ataques peleador) peleador
    | otherwise = sinEfecto peleador

patadaMuertoOVivo :: Peleador -> Peleador
patadaMuertoOVivo peleador
    | estaMuerto peleador = modificarVidaDelOponente (-10) peleador
    | otherwise = modificarVidaDelOponente 1 peleador

olvidarPrimerAtaque :: [Ataque] -> Peleador -> Peleador
olvidarPrimerAtaque (primerAtaque : ataques) peleador =
    peleador { ataques = ataques }

sinEfecto :: Peleador -> Peleador
sinEfecto peleador = peleador

-----------parte d-----------

bruceLee = UnPeleador {
    puntosDeVida = 200,
    resistencia = 25,
    ataques = [toqueDeLaMuerte, golpe 500,patada Carita,patada Carita,patada Carita]
}

miri = UnPeleador {
    puntosDeVida = 200,
    resistencia = 25,
    ataques = [toqueDeLaMuerte, golpe 500,patada Carita,patada Carita,patada Carita]
}

-----------PUNTO 2-----------
{- Dados un peleador y un enemigo, encontrar el mejor ataque del peleador contra ese
enemigo (es decir, encontrar el ataque del peleador que deja con menos vida al
enemigo) -}

mejorAtaque :: Peleador -> Peleador -> Ataque
mejorAtaque peleador enemigo =
    foldl1 (elMejorEntre enemigo) (ataques peleador)

elMejorEntre ::  Peleador -> Ataque -> Ataque -> Ataque
elMejorEntre enemigo ataque1 ataque2
    | esMejor enemigo ataque1 ataque2 = ataque1
    | otherwise = ataque2

esMejor :: Peleador -> Ataque -> Ataque -> Bool
esMejor enemigo ataque1 ataque2 = (puntosDeVida . ataque1) enemigo < (puntosDeVida . ataque2) enemigo

-----------PUNTO 3-----------

-----------parte a-----------

--un ataque es terrible para un conjunto de enemigos si, luego de
--realizarlo contra todos ellos, quedan vivos menos de la mitad.


esTerrible :: [Peleador] -> Ataque -> Bool
esTerrible enemigos ataque =
    cantidadDeVivosDespuesDelAtaque ataque enemigos < length enemigos / 2

cantidadDeVivosDespuesDelAtaque :: Ataque -> [Peleador] -> Number
cantidadDeVivosDespuesDelAtaque ataque enemigos =
    ( length . filter (not . estaMuerto) . map ataque ) enemigos

-----------parte b-----------

--un peleador es peligroso para un conjunto de enemigos si todos
--sus ataques son terribles para los miembros del conjunto que son hábiles.

esPeligroso :: Peleador -> [Peleador] -> Bool
esPeligroso peleador enemigos =
    all ( esTerrible (peleadoresHabiles enemigos) ) (ataques peleador)

peleadoresHabiles :: [Peleador] -> [Peleador]
peleadoresHabiles enemigos = filter esHabil enemigos

-----------parte c-----------
--OJO IMPORTANTE

-- un peleador es invencible para un conjunto de enemigos si,
--luego de recibir el mejor ataque de cada uno de ellos, sigue teniendo la
-- misma vida que antes de ser atacado

esInvencible :: Peleador -> [Peleador] -> Bool
esInvencible peleador enemigos =
    puntosDeVida peleador == puntosDeVida (peleadorDespuesDeLosAtaques peleador enemigos)

peleadorDespuesDeLosAtaques :: Peleador -> [Peleador] -> Peleador
peleadorDespuesDeLosAtaques peleador enemigos =
    (foldr ($) peleador . map (mejorAtaque peleador) ) enemigos