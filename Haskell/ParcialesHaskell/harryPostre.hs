{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant map" #-}
{-# HLINT ignore "Eta reduce" #-}
module Library where
import PdePreludat



-----------PUNTO 1-----------

-----------parte a-----------

data Postre = UnPostre {
    sabores :: [String],
    peso :: Number,
    temperatura :: Number
} deriving (Show,Eq)

bizcochoBorracho = UnPostre {
    sabores = ["fruta" , "crema"],
    peso = 100,
    temperatura = 25
}

tarta = UnPostre{
    sabores = ["melaza"],
    peso = 50,
    temperatura = 0
}

-----------parte b-----------

type Hechizo = Postre -> Postre
data Valor = Peso | Temperatura
data Posicion = AlPrincipio | AlFinal

incendio :: Hechizo
incendio = modificarValor Temperatura (-1) . modificarValorPorcentaje Peso (-5)

modificarValor :: Valor -> Number -> Postre -> Postre
modificarValor Temperatura cantidad postre = postre {temperatura = temperatura postre + cantidad}
modificarValor Peso cantidad postre = postre {peso = peso postre + cantidad}

modificarValorPorcentaje :: Valor -> Number -> Postre -> Postre
modificarValorPorcentaje Temperatura cantidad postre = postre {temperatura = temperatura postre + temperatura postre * cantidad / 100}
modificarValorPorcentaje Peso cantidad postre = postre {peso = peso postre + peso postre * cantidad / 100}


immobulus :: Hechizo
immobulus = congelarPostre

congelarPostre :: Postre -> Postre
congelarPostre postre = postre {temperatura = 0}


wingardiumLeviosa :: Hechizo
wingardiumLeviosa = levantarYDejarCaerPostre . modificarValorPorcentaje Peso (-10)

levantarYDejarCaerPostre :: Postre -> Postre
levantarYDejarCaerPostre = agregarSabor "concentrado" AlPrincipio

agregarSabor :: String -> Posicion -> Postre -> Postre
agregarSabor saborNuevo AlPrincipio postre = postre {sabores = saborNuevo : sabores postre}
agregarSabor saborNuevo AlFinal postre = postre {sabores = sabores postre ++ [saborNuevo] }

diffindo :: Number -> Hechizo
diffindo = cortarPostre

cortarPostre :: Number -> Postre -> Postre
cortarPostre = modificarValorPorcentaje Peso

riddikkulus :: String -> Hechizo
riddikkulus sabor = agregarSabor sabor AlFinal

avadaKedavra :: Hechizo
avadaKedavra = immobulus . perderLosSabores

perderLosSabores :: Postre -> Postre
perderLosSabores postre = postre {sabores = [] }

-----------parte c-----------

type Postres = [Postre]

postresListos :: Postres -> Hechizo -> Bool
postresListos postres hechizo = (all estaListo . map hechizo) postres

estaListo :: Postre -> Bool
estaListo postre =
    peso postre > 0 && sabores postre /= [] && not (estaCongelado postre)

estaCongelado postre = temperatura postre == 0


-----------parte d-----------

pesoPromedioDePostresListos :: Postres -> Number
pesoPromedioDePostresListos postres = (flip div (cantidadDePostresListos postres) . sum . map peso . filter estaListo) postres

cantidadDePostresListos :: Postres -> Number
cantidadDePostresListos postres = length (filter estaListo postres)

-----------PUNTO 2-----------

data Mago = UnMago {
    hechizosAprendidos :: [Hechizo],
    cantidadDeHorrocruxes :: Number
} deriving(Eq,Show)

miri = UnMago {
    hechizosAprendidos = [immobulus,incendio,avadaKedavra],
    cantidadDeHorrocruxes = 66
}

postreDeMiri = UnPostre {
    sabores = ["cocholate", "dulcedelexe","frutila"],
    peso = 66,
    temperatura = 180
}

-----------parte a-----------

practicarHechizo :: Postre -> Mago -> Hechizo -> Mago
practicarHechizo postre mago hechizo 
    | hechizo postre == avadaKedavra postre = (agregarAHechizosAprendidos hechizo . sumarUnHorrorcrux) mago
    | otherwise = agregarAHechizosAprendidos hechizo mago

agregarAHechizosAprendidos :: Hechizo -> Mago -> Mago
agregarAHechizosAprendidos hechizo mago = mago { hechizosAprendidos = hechizo : hechizosAprendidos mago}

sumarUnHorrorcrux :: Mago -> Mago
sumarUnHorrorcrux mago = mago { cantidadDeHorrocruxes = cantidadDeHorrocruxes mago + 1 }

-----------parte b-----------
{- Dado un postre y un mago obtener su mejor hechizo, que es aquel de sus hechizos que deja al
postre con más cantidad de sabores luego de usarlo-}

mejorHechizoDelMago :: Postre -> Mago -> Hechizo
mejorHechizoDelMago postre (UnMago (hechizo1:hechizo2:hechizos) cantidadDeHorrocruxes)
    | (cantidadDeSaboresDelPostre . aplicarHechizo postre) hechizo1 > 
    (cantidadDeSaboresDelPostre . aplicarHechizo postre) hechizo2  =
        mejorHechizoDelMago postre (UnMago (hechizo1:hechizos) cantidadDeHorrocruxes)
    | otherwise = mejorHechizoDelMago postre (UnMago (hechizo2:hechizos) cantidadDeHorrocruxes)
 

cantidadDeSaboresDelPostre :: Postre -> Number
cantidadDeSaboresDelPostre postre = ( length . sabores ) postre

aplicarHechizo :: Postre -> Hechizo -> Postre
aplicarHechizo postre hechizo = hechizo postre


--esto esta bien OJOOO
{-- Otra versión
mejorhechizoV2 ::  Postre -> Mago -> Hechizo
mejorhechizoV2 postre mago = foldl1 (elMejorEntre postre) (hechizos mago)

elMejorEntre :: Postre -> Hechizo -> Hechizo -> Hechizo
elMejorEntre postre hechizo1 hechizo2 
    | esMejor postre hechizo1 hechizo2 = hechizo1
    | otherwise = hechizo2
    
esMejor :: Postre -> Hechizo -> Hechizo -> Bool
esMejor postre hechizo1 hechizo2 = (length . sabores . hechizo1) postre > (length . sabores . hechizo2) postre

 Otra versión más
mejorhechizoV3 ::  Postre -> Mago -> Hechizo
mejorhechizoV3 postre mago = mejorGenerico (\hechizo -> (length.sabores.hechizo) postre) (hechizos mago)

mejorGenerico :: Ord a => (b -> a) ->[b] -> b
mejorGenerico criterio elementos = foldl1 (elMejorEntreGenerico criterio) (elementos)

elMejorEntreGenerico :: Ord a => (b -> a) -> b -> b -> b
elMejorEntreGenerico criterio elemento1 elemento2
    | criterio elemento1 > criterio elemento2 = elemento1
    | otherwise = elemento2 -}

-----------PUNTO 3-----------

-----------parte a-----------

postresInfinitos :: Postres
postresInfinitos = repeat tarta
 

magoInfinito = UnMago{
    hechizosAprendidos = repeat incendio,
    cantidadDeHorrocruxes = 50
}
