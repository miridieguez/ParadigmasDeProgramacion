{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use elem" #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Redundant map" #-}
{-# HLINT ignore "Redundant bracket" #-}
module Library where
import PdePreludat
import Data.Char (isUpper)

data Plomero = UnPlomero {
    nombre :: String,
    cajaDeHerramientas :: [Herramienta],
    historialDeReparaciones :: [Reparacion],
    dinero :: Number
} deriving (Eq,Show)

data Herramienta = UnaHerramienta {
    denominacion :: String,
    precio :: Number,
    material :: Material
} deriving (Eq, Show)

data Material = Hierro | Madera | Goma | Plastico deriving (Eq, Show)

-----------PUNTO 1-----------

mario = UnPlomero {
    nombre = "Mario",
    cajaDeHerramientas = [llaveInglesa, martillo],
    historialDeReparaciones = [],
    dinero = 1200
}

llaveInglesa = UnaHerramienta {
    denominacion = "llave inglesa",
    precio= 200,
    material=Hierro
    }

martillo = UnaHerramienta {
    denominacion = "martillo",
    precio= 20,
    material=Madera
    }

wario = UnPlomero {
    nombre = "Wario",
    cajaDeHerramientas = iterate (aumentarPrecio 1) llaveFrancesa  ,
    historialDeReparaciones = [],
    dinero = 0.5
}

aumentarPrecio :: Number -> Herramienta -> Herramienta
aumentarPrecio numero herramienta = herramienta {precio = precio herramienta + numero}

llaveFrancesa = UnaHerramienta {
    denominacion = "llave francesa",
    precio= 1 ,
    material = Hierro
    }

-----------PUNTO 2-----------

-----------parta a-----------
--Saber si tiene una herramienta con cierta denominación.

tieneHerramienta :: String -> Plomero -> Bool
tieneHerramienta herramienta plomero = ( any (== herramienta) . map denominacion . cajaDeHerramientas ) plomero

-----------parta b-----------
--Es malvado: se cumple si su nombre empieza con Wa.

esMalvado :: Plomero -> Bool
esMalvado plomero =
    take 2 (nombre plomero) == "Wa"


-----------parte c-----------
--Puede comprar una herramienta: esto sucede si tiene el dinero suficiente para pagar el precio de la misma.

puedeComprarHerramienta :: Herramienta -> Plomero -> Bool
puedeComprarHerramienta herramienta plomero =
    dinero plomero >= precio herramienta

-----------PUNTO 3-----------
--Saber si una herramienta es buena, cumpliendose solamente si tiene empuñadura de hierro 
--que sale más de $10000 o es un martillo con mango de madera o goma.

esBuenaLaHerramienta :: Herramienta -> Bool
esBuenaLaHerramienta herramienta =
    ( material herramienta == Hierro && precio herramienta >1000 ) ||
    ( denominacion herramienta == "martillo" && (material herramienta == Madera || material herramienta == Goma ) )

-----------PUNTO 4-----------
comprarHerramienta :: Herramienta -> Plomero -> Plomero
comprarHerramienta herramienta plomero
    | puedeComprarHerramienta herramienta plomero = plomero {dinero = dinero plomero - precio herramienta ,
    cajaDeHerramientas = herramienta: cajaDeHerramientas plomero }
    | otherwise = plomero

-----------PUNTO 5-----------
-----------parte a-----------

--seria mejor hacer que los requerimientos sean de tipo plomero -> Bool , como condiciones y ahi poner las funciones
-- tiene tal herramienta, etc

data Reparacion = UnaReparacion {
    descripcion :: String,
    requerimiento :: Herramienta
} deriving (Eq,Show)

filtracionDeAgua = UnaReparacion {
    descripcion = "el plomero debera tapar el canio",
    requerimiento = llaveInglesa
}

-----------parte b-----------
--Saber si una reparación es difícil: esto ocurre cuando su descripción es complicada, es decir que tiene más de 
--100 caracteres y además es un grito, es decir está escrito totalmente en mayúsculas

esDificil :: Reparacion -> Bool
esDificil reparacion =
    length (descripcion reparacion) > 100 && esUnGrito (descripcion reparacion)

esUnGrito :: String -> Bool
esUnGrito palabras = all esMayuscula palabras

esMayuscula = isUpper

-----------parte c-----------
presupuestoDeLaReparacion :: Reparacion -> Number
presupuestoDeLaReparacion reparacion =
    length (descripcion reparacion) * (div porcentajePorReparacion 100)

porcentajePorReparacion = 300

-----------PUNTO 6-----------

hacerReparacion :: Reparacion -> Plomero -> Plomero
hacerReparacion reparacion plomero
    | (cumpleRequierimiento plomero reparacion) || (esMalvado plomero && tieneHerramienta "martillo" plomero) = plomerosQueCumplenRequerimientos reparacion plomero
    | otherwise = plomero {dinero = dinero plomero + 100}

plomerosQueCumplenRequerimientos :: Reparacion -> Plomero -> Plomero
plomerosQueCumplenRequerimientos reparacion plomero
    | esMalvado plomero = (modificarDineroYHistorial reparacion . robarACliente destornillador) plomero
    | otherwise = plomerosBuenos reparacion plomero

plomerosBuenos :: Reparacion -> Plomero -> Plomero
plomerosBuenos reparacion plomero 
    | esDificil reparacion = (modificarDineroYHistorial reparacion . perderHerramientasBuenas) plomero
    | otherwise = (modificarDineroYHistorial reparacion . olvidarPrimeraHerramienta) plomero

olvidarPrimeraHerramienta :: Plomero -> Plomero
olvidarPrimeraHerramienta plomero = plomero {cajaDeHerramientas = tail (cajaDeHerramientas plomero)}

perderHerramientasBuenas :: Plomero -> Plomero
perderHerramientasBuenas plomero = plomero {cajaDeHerramientas = filter (not . esBuenaLaHerramienta) (cajaDeHerramientas plomero) }

-- otra opcion hacer el filter directamente asi 
--esMalaLaHerramienta herramienta = not (esBuenaLaHerramienta herramienta)

robarACliente :: Herramienta -> Plomero -> Plomero
robarACliente herramienta plomero = plomero {cajaDeHerramientas = herramienta: cajaDeHerramientas plomero}
modificarDineroYHistorial :: Reparacion -> Plomero -> Plomero
modificarDineroYHistorial reparacion plomero = (agregarReparacionAHistorial reparacion . sumarPresupuesto reparacion) plomero

agregarReparacionAHistorial :: Reparacion -> Plomero -> Plomero
agregarReparacionAHistorial reparacion plomero = plomero {historialDeReparaciones = reparacion : historialDeReparaciones plomero}

sumarPresupuesto :: Reparacion -> Plomero -> Plomero
sumarPresupuesto reparacion plomero = plomero {dinero = dinero plomero + presupuestoDeLaReparacion reparacion}

destornillador = UnaHerramienta {
    denominacion = "destornillador con mango de plastico",
    precio = 0,
    material = Plastico
}
cumpleRequierimiento :: Plomero -> Reparacion -> Bool
cumpleRequierimiento plomero reparacion =
    any (==requerimiento reparacion) (cajaDeHerramientas plomero)


-----------PUNTO 7-----------
{-Cada plomero realiza varias reparaciones en un día. Necesitamos saber cómo afecta a un plomero una jornada de trabajo.-}

jornadaLaboral :: Reparaciones -> Plomero -> Plomero
jornadaLaboral reparaciones plomero = foldr hacerReparacion plomero reparaciones

-----------PUNTO 8-----------

-----------parte a-----------
--El empleado más reparador: El plomero que más reparaciones tiene en su historial una vez realizada su jornada laboral.
type Plomeros = [Plomero]
type Reparaciones = [Reparacion]

empleadoMasReparador :: Plomeros -> Reparaciones -> Plomero
empleadoMasReparador plomeros reparaciones = (cualTieneMasReparaciones . map (jornadaLaboral reparaciones) ) plomeros

cualTieneMasReparaciones :: Plomeros -> Plomero
cualTieneMasReparaciones (plomero1:plomero2:plomeros) 
    | length (historialDeReparaciones plomero1) < length (historialDeReparaciones plomero2) = cualTieneMasReparaciones (plomero2:plomeros)
    | otherwise = cualTieneMasReparaciones (plomero1:plomeros) 



--El empleado más adinerado: El plomero que más dinero tiene encima una vez realizada su jornada laboral.
--El empleado que más invirtió: El plomero que más plata invertida tiene entre las herramientas que le quedaron una vez realizada su jornada laboral.


