{-# OPTIONS_GHC -Wno-missing-fields #-}
module Library where
import PdePreludat
import Data.Ratio (numerator)

-- 1. Tuplas

--first :: (a, b, c) -> a     che porque esto no hace falta?
first (a, _, _) = a

--second :: (a, b, c) -> b
second (_, b, _ ) = b

--third :: (a,b,c) -> c 
third (_, _, c) = c

swap (a, b)= (b, a)

divisionConResto :: Number -> Number -> (Number, Number)
divisionConResto dividendo divisor = (div dividendo divisor, rem dividendo divisor)
--OTRA FORMA:divisionConResto dividendo divisor = (dividendo `div` divisor, dividendo `rem` divisor)


-- 2. Titulos
miranda = Persona {
    nombre = "Miranda",
    anios = 19,
    titulo = Ingenieria,
    apellido = "Dieguez"
}

ale = Persona {
    nombre = "Ale",
    anios = 19,
    titulo = NoTiene,
    apellido = "Peralta"
}

carolina = Persona {
    nombre = "Carolina Maria",
    anios = 57,
    titulo = Doctorado,
    apellido = "Ravier"
}

data Persona = Persona {
    nombre :: String,
    anios :: Number,
    titulo :: Titulo,
    apellido :: String
} deriving (Eq, Show)

edad :: Persona -> Number
edad = anios

abreviacionTitulo :: Titulo -> String
abreviacionTitulo Ingenieria = "Ing."
abreviacionTitulo Licenciatura = "Lic."
abreviacionTitulo Doctorado = "Doc."
abreviacionTitulo (Dev experiencia)  = abreviacionDev experiencia

abreviacionDev :: Experiencia -> String
abreviacionDev experiencia
    | experiencia >= 0 && experiencia <=1 = "Dev Jr."
    | experiencia >1 && experiencia <=5 = "Ssr."
    | otherwise = "Dev Sr."

nombreCompleto :: Persona -> String
nombreCompleto unaPersona = abreviacionTitulo (titulo unaPersona) ++ " " ++ nombre unaPersona ++ " " ++ apellido unaPersona
--nombreCompleto unaPersona = abreviacionTitulo (unaPersona) ++ " " ++ nombre unaPersona ++ " " ++ apellido unaPersona


edadRecibida :: Titulo -> Number
edadRecibida Ingenieria = 6
edadRecibida Licenciatura = 4
edadRecibida Doctorado = 2
edadRecibida NoTiene = 0
edadRecibida (Dev experiencia)
    | experiencia == 0 = 2
    | experiencia > 0 = 2* experiencia


recibirse :: Titulo -> Persona -> Persona
recibirse unTitulo unaPersona = unaPersona {anios = anios unaPersona + edadRecibida unTitulo, titulo = unTitulo}

-- 3. Pregunta

-- Si yo tengo a un estudiante que tiene 26 años, se llama Juan Fernandes y tiene título de Ingeniería:
 -- Escriban el código de como sería

juan = Persona {
    nombre = "Juan",
    anios = 26,
    titulo = Ingenieria,
    apellido = "Fernandes"
}

-- y en ghci evaluo el código que haría que juan se reciba de un doctorado

-- Y luego le pido a ghci que evalue

-- edad juan

-- ¿cuantos años me va a devolver esa ultima consulta? ¿Por qué?
-- Respuesta: 
-- Me devuelve la edad original. 
-- Transparencia referencial: siempre que se evalúa el mismo bloque de software con los mismos parámetros, se obtiene el mismo resultado, sin importar el comportamiento interno de dicho bloque.
-- La evaluación de un bloque de código no produce un cambio en el estado de información del sistema que pueda afectar una posterior evaluación del mismo u otro bloque.
-- Se dice que una expresión es referencialmente transparente sí se puede reemplazar con su valor correspondiente sin cambiar el comportamiento del programa. Como resultado, la evaluación de una función referencialmente da el mismo valor para los mismos argumentos. Estas funciones se llaman funciones puras

-- 4. Devs


type Experiencia = Number
data Titulo = Ingenieria | Licenciatura | Doctorado | NoTiene | Dev Experiencia deriving (Eq, Show)

practicar :: Persona -> Number -> Persona
practicar (Persona _ anios (Dev experiencia) _) aniosDePractica = Persona {anios = anios + aniosDePractica, titulo= Dev (experiencia+aniosDePractica)}
practicar (Persona _ anios titulo _) aniosDePractica = Persona {anios = anios + aniosDePractica}


