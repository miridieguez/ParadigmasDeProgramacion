{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Parenthesize unary negation" #-}
module Library where
import PdePreludat

data Personaje = UnPersonaje {
    nombre :: String,
    dinero :: Number,
    felicidad :: Number
}  deriving (Show,Eq)

-----------PUNTO 1-----------

data Valor = Dinero | Felicidad deriving (Show,Eq)

type Actividad = Personaje -> Personaje

irALaEscuela :: Actividad
irALaEscuela personaje
    | nombre personaje == "lisa" = cambiarValor Felicidad 10 personaje
    | otherwise = cambiarValor Felicidad (-10) personaje

cambiarValor :: Valor -> Number -> Personaje -> Personaje
cambiarValor Dinero numero personaje = personaje { dinero = dinero personaje + numero `max` 0}
cambiarValor Felicidad numero personaje = personaje { felicidad = felicidad personaje + numero `max` 0}


comerDonas :: Number -> Actividad
comerDonas cantidad = cambiarValor Felicidad (10 * cantidad) . cambiarValor Dinero ( (-10) * cantidad)


irATrabajar :: String -> Actividad
irATrabajar trabajo = cambiarValor Dinero (length trabajo)

serDirector :: Actividad
serDirector = irATrabajar "escuela elemental" . cambiarValor Felicidad (-10)

tomarBirritasEn2x1 :: Number -> Actividad
tomarBirritasEn2x1 cantidad = cambiarValor Felicidad (20 * cantidad) . cambiarValor Dinero ( 5 * cantidad/2 )

sinEfecto:: Personaje -> Personaje
sinEfecto personaje = personaje

lisa = UnPersonaje {
    nombre = "Lisa",
    dinero = 6,
    felicidad = 100
}

homero = UnPersonaje {
    nombre = "Homero",
    dinero = 3000,
    felicidad = 200
}

skinner = UnPersonaje {
    nombre = "Skinner",
    dinero = 1000,
    felicidad = 20
}


{-Otra forma:
homero, skinner, lisa :: Personaje

homero = UnPersonaje "Homero Simpson" 50 100
skinner = UnPersonaje "Skinner" 10 500
lisa = UnPersonaje "Lisa Simpson" 100 0
-}

-----------PUNTO 2-----------

burns = UnPersonaje {
    nombre = "Sr. Burns",
    dinero = 90000,
    felicidad = 5
}

type Logro = Personaje -> Bool

serMillonario :: Logro
serMillonario personaje = dinero personaje > dinero burns

alegrarse :: Number -> Logro
alegrarse felicidadDeseada personaje = felicidad personaje > felicidadDeseada

verAKrosty :: Logro
verAKrosty personaje = dinero personaje >= 10

serInfeliz :: Logro
serInfeliz personaje = felicidad personaje >=0 && felicidad personaje < felicidad burns

-----------parte A-----------

esActividadDesisivaParaUnLogro ::  Personaje -> Logro -> Actividad -> Bool
esActividadDesisivaParaUnLogro personaje logro actividad 
    |logro personaje = False  --OSEA SI DE POR SI YA PUEDE CUMPLIR EL LOGRO ESTO NO TIENE SENTIDO
    | otherwise = (logro . actividad) personaje

-----------parte B-----------
hacerActividadDesisiva :: Personaje -> Logro -> [Actividad] -> Personaje
hacerActividadDesisiva personaje logro actividades
    | any (esActividadDesisivaParaUnLogro personaje logro) actividades = 
         ( hacerActividad personaje . head . filter (esActividadDesisivaParaUnLogro personaje logro)) actividades 
    | otherwise = personaje
    --OJO DIFICIL

hacerActividad :: Personaje -> Actividad -> Personaje
hacerActividad personaje actividad = actividad personaje 

actividadesInfinitas :: [Actividad]
actividadesInfinitas = repeat (tomarBirritasEn2x1 5)

--Este es mas general:
{-hacerActividadesInfinitas :: Actividades -> Actividades
hacerActividadesInfinitas actividades = actividades ++ hacerActividadesInfinitas actividades-}

--concatena la lista de actividades y vuelve a llamar a esa funcion
