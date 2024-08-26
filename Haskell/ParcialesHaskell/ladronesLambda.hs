{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use newtype instead of data" #-}
{-# HLINT ignore "Use null" #-}
{-# HLINT ignore "Eta reduce" #-}
module Library where
import PdePreludat
import Data.Char (isUpper, isDigit, toUpper)

anioActual :: Number
anioActual = 2024

-- Explicación de funciones importadas para el punto 2

-- isUpper :: Char -> Bool
-- Devuelve True si un Char es una letra y además es mayúscula. Si no, False.
-- >>> isUpper 'a'
-- False
-- >>> isUpper 'A'
-- True

-- isDigit :: Char -> Bool
-- Devuelve True si un Char es un dígito decimal. Si no, False.
-- >>> isDigit '3'
-- True
-- >>> isDigit '?'
-- False

-- toUpper :: Char -> Char
-- Dado un Char, si es una letra devuelve la misma letra en mayúscula,
-- si no es una letra devuelve el Char como estaba.
-- >>> toUpper 'a'
-- 'A'
-- >>> toUpper '3' 
-- '3'

-------------------------
--------PARTE 1----------
-------------------------

data Tesoro = Tesoro {
    anioDescubrimiento :: Number,
    precio :: Number
} deriving (Eq,Show)

data Tipo = DeLujo | TelaSucia | Estandar deriving (Eq,Show)

--------parte A----------

tipoDelTesoro :: Tesoro -> Tipo
tipoDelTesoro tesoro
    | precio tesoro > minimoPrecioParaSerDeLujo || antiguedad tesoro > minimaAntiguedadParaSerDeLujo = DeLujo
    | otherwise = evaluarOtrosTipos tesoro

minimoPrecioParaSerDeLujo = 1000
minimaAntiguedadParaSerDeLujo = 200

evaluarOtrosTipos :: Tesoro -> Tipo
evaluarOtrosTipos tesoro
    | precio tesoro < maximoPrecioParaSerTelaSucia = TelaSucia
    | otherwise = Estandar

maximoPrecioParaSerTelaSucia = 50

antiguedad :: Tesoro -> Number
antiguedad tesoro = anioActual - anioDescubrimiento tesoro

--------parte B----------

valorDelTesoro :: Tesoro -> Number
valorDelTesoro tesoro = precio tesoro + numeroParaMultiplicarLaAntiguedad * antiguedad tesoro

numeroParaMultiplicarLaAntiguedad = 2

-------------------------
--------PARTE 2----------
-------------------------

data Cerradura = Cerradura{
    clave :: [Char]
} deriving (Eq,Show)


type Herramienta = (Cerradura -> Cerradura)


martillo :: Herramienta
martillo = quitarPrimerosCaracteres 3

quitarPrimerosCaracteres :: Number -> Cerradura -> Cerradura
quitarPrimerosCaracteres cantidad cerradura =
    cerradura { clave = drop cantidad (clave cerradura) }

llaveMaestra :: Herramienta
llaveMaestra = abrirCerradura

abrirCerradura :: Cerradura -> Cerradura
abrirCerradura cerradura = 
    cerradura { clave = []}

data TipoGanzua = Gancho | Rastrillo | Rombo [Char] deriving(Eq,Show)

ganzua :: TipoGanzua -> Herramienta
ganzua Gancho = quitarPrimerosCaracteres 1 . eliminarDeLaClave isUpper
ganzua Rastrillo = quitarPrimerosCaracteres 1 . eliminarDeLaClave isDigit
ganzua (Rombo inscripcion)= quitarPrimerosCaracteres 1 . eliminarInscripcionDeLaClave inscripcion

eliminarDeLaClave :: (Char -> Bool) -> Cerradura -> Cerradura
eliminarDeLaClave funcion cerradura = 
    cerradura { clave = filter (not. funcion) (clave cerradura) }

eliminarInscripcionDeLaClave :: [Char] -> Cerradura -> Cerradura
eliminarInscripcionDeLaClave inscripcion cerradura =
    cerradura { clave = eliminarRepetidos (clave cerradura) inscripcion}

eliminarRepetidos :: [Char] -> [Char] -> [Char]
eliminarRepetidos clave inscripcion =
    filter (not . flip elem inscripcion) clave

tensor :: Herramienta
tensor = convertirMinusculasEnMayusculas

convertirMinusculasEnMayusculas :: Cerradura -> Cerradura
convertirMinusculasEnMayusculas cerradura = 
    cerradura { clave = map toUpper (clave cerradura)}

socotroco :: Herramienta -> Herramienta -> Herramienta
socotroco herramienta1 herramienta2 = aplicarHerramienta herramienta1 . aplicarHerramienta herramienta2

aplicarHerramienta :: Herramienta -> Cerradura -> Cerradura
aplicarHerramienta herramienta cerradura = herramienta cerradura


-------------------------
--------PARTE 3----------
-------------------------


data Ladron = Ladron {
    nombre :: String,
    herramientas :: [Herramienta],
    tesorosRobados :: [Tesoro]
}

data Cofre = Cofre {
    cerraduraDelCofre :: Cerradura,
    tesoroDelCofre :: Tesoro
}

--------parte A----------


experienciaDeUnLadron :: Ladron -> Number
experienciaDeUnLadron ladron =
    (sum . map valorDelTesoro ) (tesorosRobados ladron)

esLegendario :: Ladron -> Bool
esLegendario ladron = 
    experienciaDeUnLadron ladron > experienciaNecesariaParaSerLegendario && all esDeLujo (tesorosRobados ladron)

experienciaNecesariaParaSerLegendario = 100

esDeLujo :: Tesoro -> Bool
esDeLujo tesoro = tipoDelTesoro tesoro == DeLujo

--------parte B----------

robarCofre :: Ladron -> Cofre -> Ladron
robarCofre (Ladron nombre [] tesorosRobados) (Cofre cerraduraDelCofre tesoroDelCofre) = Ladron nombre [] tesorosRobados 
robarCofre (Ladron nombre (x:xs) tesorosRobados) (Cofre cerraduraDelCofre tesoroDelCofre) 
    | cerraduraAbierta cerraduraDelCofre = modificarLadronDespuesDelRobo (Ladron nombre (x:xs) tesorosRobados) (Cofre cerraduraDelCofre tesoroDelCofre)
    | otherwise = robarCofre (Ladron nombre xs tesorosRobados) (Cofre (aplicarHerramienta x cerraduraDelCofre) tesoroDelCofre)

cerraduraAbierta cerradura = clave cerradura == []

modificarLadronDespuesDelRobo :: Ladron -> Cofre -> Ladron
modificarLadronDespuesDelRobo ladron cofre = agregarTesoro (tesoroDelCofre cofre) ladron

agregarTesoro :: Tesoro -> Ladron -> Ladron
agregarTesoro tesoronuevo ladron = ladron { tesorosRobados = tesoronuevo : tesorosRobados ladron }


--------parte C----------

type Cofres = [Cofre]

atraco :: Ladron -> Cofres -> Ladron
atraco ladron cofres = foldl robarCofre ladron cofres 

--------parte D----------
{-

i)   un atraco en el que aparezca una lista infinita en algún lado y que por eso la expresión no termine

Si el ladron tiene la herramienta abrir cerradura, siempre podra hacer el atraco no importa si hay una lista infinita en algun lado
ya que lo que hace esa herramienta es vaciar la lista de la clave y abrir la cerradura . Al abrir la cerradura se habra concretado
el robo

Si el ladron no tiene esa herramienta y la clave de la cerradura del cofre es infinita, nunca podra vaciar esa lista y por lo tanto
abrir la cerradura.
Aqui hay un ejemplo que no terminara nunca si ASUMIMOS que el ladron NO TIENE la herramienta ABRIR CERRADURA

oro = Tesoro {
    anioDescubrimiento = 2024,
    precio = 10
}
cerradura = Cerradura{
    clave = repeat 'a'
}
cofre = Cofre {
    cerraduraDelCofre = cerradura,
    tesoroDelCofre = oro
}

ii)  un atraco en el que aparezca una lista infinita en algún lado pero que aún así evaluar esa expresión termine.
            
oro = Tesoro {
    anioDescubrimiento = 2024,
    precio = 10
}


miri = Ladron{
    nombre = "Miranda",
    herramientas = [],
    tesorosRobados = repeat oro
}

los tesoros robados del ladron antes del atraco no van a influir en nada, ya que lo unico que se va a realizar
es agregar el tesoro nuevo a la lista de tesoros robados, pero para eso no se necesita recorrer la lista infinita


-}


