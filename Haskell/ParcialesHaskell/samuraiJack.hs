{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Use :" #-}
module Library where
import PdePreludat


data Elemento = UnElemento { 
    tipo :: String,
    ataque :: (Personaje-> Personaje),
    defensa :: (Personaje-> Personaje) 
    } deriving(Eq,Show)

data Personaje = UnPersonaje { 
    nombre :: String,
    salud :: Number,
    elementos :: [Elemento],
    anioPresente :: Number 
    } deriving(Eq,Show)

--------------------------COSAS MIAS-----------------------------
miri = UnPersonaje {
    nombre= "Miranda",
    salud = 15,
    elementos = [UnElemento { tipo = "Maldad", ataque =  modificarSalud CausarDanio 3, defensa = modificarSalud Meditar 1 }],
    anioPresente = 2024
}
caro = UnPersonaje {
    nombre= "Carolina",
    salud = 30,
    elementos = [UnElemento { tipo = "Bondad", ataque = modificarSalud CausarDanio 9, defensa = sinEfecto }, UnElemento { tipo = "Maldad", ataque = modificarSalud CausarDanio 1, defensa = sinEfecto }],
    anioPresente = 2024
}


--------------------------------------------------------------



---------------------------RESOLUCION--------------------------

----------------------------------------------------------------
----------------------------PUNTO 1-----------------------------
----------------------------------------------------------------
data Actividad = Meditar | CausarDanio 

mandarAlAnio :: Number -> Personaje -> Personaje
mandarAlAnio anio personaje = personaje { anioPresente = anio }

modificarSalud :: Actividad -> Number -> Personaje -> Personaje
modificarSalud Meditar veces personaje = personaje { salud = ( salud personaje + salud personaje / 2 ) * veces }
modificarSalud CausarDanio danio personaje = personaje { salud = (salud personaje - danio)  `max` 0}

-------------SOLUCION CON REPETICION DE LOGICA----------------
{-meditar :: Number -> Personaje -> Personaje
meditar veces personaje = personaje { salud = ( salud personaje + salud personaje / 2 ) * veces }

causarDanio :: Number -> Personaje -> Personaje
causarDanio danio personaje = personaje { salud = (salud personaje - danio)  `max` 0}-}


----------------------------------------------------------------
----------------------------PUNTO 2-----------------------------
----------------------------------------------------------------

esMalvado :: Personaje -> Bool
esMalvado personaje = 
    any ((\elemento -> tipo elemento == "Maldad")) (elementos personaje)

-----OTRA POSIBILIDAD----
--esMalvado personaje = any (esElemento "Maldad") (elementos personaje)
--esElemento :: String -> Elemento -> Bool
--esElemento elementoDeseado elemento = elementoDeseado == tipo elemento

danioQueProduce :: Personaje -> Elemento -> Number
danioQueProduce personaje elemento = 
    salud personaje - salud (ataque elemento personaje)

enemigosMortales :: Personaje -> [Personaje] -> [Personaje]
enemigosMortales personaje enemigos = 
    filter (esEnemigo personaje) enemigos

esEnemigo :: Personaje -> Personaje -> Bool
esEnemigo personaje posibleEnemigo =
     any (saludCero personaje) (elementos posibleEnemigo)

------OTRA FORMA MUY SIMILAR---------
{-esEnemigo personaje enemigo =
  (any (saludCero personaje) . elementos) enemigo-}

saludCero :: Personaje -> Elemento -> Bool
saludCero personaje elemento = 
    danioQueProduce personaje elemento == salud personaje

------OTRA FORMA MUY SIMILAR---------
{-saludCero personaje elemento = 
    (estaMuerto . ataque elemento) personaje

estaMuerto:: Personaje -> Bool
estaMuerto personaje = salud personaje == 0-}


----------------------------------------------------------------
----------------------------PUNTO 3-----------------------------
----------------------------------------------------------------
--sinEfecto :: Personaje -> Personaje
--sinEfecto personaje = personaje

sinEfecto = id  --OJO

concentracion :: Number -> Elemento
concentracion nivel = UnElemento {
    tipo = "Magia",
    ataque = sinEfecto,
    defensa = modificarSalud Meditar nivel
    }

------OJO IMPORTANTE ESTAS DOS FORMAS-------
{-    defensa = (!! nivelDeConcentracion) . iterate meditar }
               -- equivalente con composición y aplicación parcial para:
               -- defensa = (\personaje -> iterate meditar personaje !! nivelDeConcentracion) }
               -- otra versión super interesante:
               -- defensa = foldr1 (.) (replicate nivelDeConcentracion meditar)
               -- por ejemplo (concentracion 3) resultaría en meditar.meditar.meditar-}
--A mi no me quedo asi porque preferi modificar la funcion de meditar,que le pases un numero y lo haga esa cantidad de veces

esbirro :: Elemento
esbirro = UnElemento {
    tipo = "Maldad",
    ataque = modificarSalud CausarDanio 1,
    defensa = sinEfecto
    }

esbirrosMalvados :: Number -> [Elemento]
esbirrosMalvados cantidad = replicate cantidad esbirro

jack :: Personaje
jack = UnPersonaje {
    nombre= "Jack",
    salud = 300,
    elementos = [concentracion 3, katanaMagica],
    anioPresente = 200
}

katanaMagica :: Elemento
katanaMagica = UnElemento {
    tipo = "Magia",
    ataque = modificarSalud CausarDanio 1000,
    defensa = sinEfecto
    }

aku :: Number -> Number -> Personaje
aku anio salud = UnPersonaje {
    nombre = "Aku",
    salud = salud,
    elementos = [concentracion 4, UnElemento { tipo = "Magia", ataque = mandarAlAnio (2800+anio), defensa = crearAkuDelFuturo }] ++ esbirrosMalvados (100*anio) ,
--  elementos = UnElemento {tipo = "Magia", ataque = mandarAlAnio (2800+anio),defensa = crearAkuDelFuturo} : esbirrosMalvados (100*anio),
    anioPresente = anio
}

crearAkuDelFuturo :: Personaje -> Personaje
crearAkuDelFuturo akuDelPasado= aku (2800 + anioPresente akuDelPasado) (salud akuDelPasado)
    
 -----------OTRA OPCION DECLARANDO VARIABLE----------------
{-aku anio saludInicial = UnPersonaje {
  nombre = "Aku",
  salud = saludInicial,
  anioPresente = anio,
  elementos = concentracion 4 : portalAlFuturoDesde anio : esbirrosMalvados (100 * anio)
}
portalAlFuturoDesde anio = UnElemento "Magia" (mandarAlAnio anioFuturo) (aku anioFuturo.salud)
  where anioFuturo = anio + 2800
-}

----------------------------------------------------------------
----------------------------PUNTO 4-----------------------------
----------------------------------------------------------------
------NO SUPE HACERLO PORQUE JUEGA CON LOS EFECTOS---------

estaMuerto:: Personaje -> Bool
estaMuerto personaje = salud personaje == 0 


luchar :: Personaje -> Personaje -> (Personaje, Personaje)
luchar atacante defensor
 |estaMuerto atacante = (defensor, atacante)
 |otherwise = luchar proximoAtacante proximoDefensor
 where proximoAtacante = usarElementos ataque defensor (elementos atacante)
       proximoDefensor = usarElementos defensa atacante (elementos atacante)

-- Abstraemos cómo hacer para usar uno de los efectos de un conjunto de elementos sobre un personaje
usarElementos :: (Elemento -> Personaje -> Personaje) -> Personaje -> [Elemento] -> Personaje
usarElementos funcion personaje elementos = foldl afectar personaje (map funcion elementos)

afectar personaje funcion = funcion personaje
afectar' = flip ($)

----MI RESOLUCION-------
{-
luchar:: Personaje -> Personaje -> (Personaje,Personaje)
luchar atacante defensor 
    | estaMuerto defensor = (defensor,atacante) --lo inverti porque viene del foldr invertido
    | otherwise = atacar atacante defensor

atacar ::  Personaje -> Personaje -> (Personaje,Personaje)
atacar atacante defensor =( foldr ($) defensor (elementosDeAtaque (elementos atacante) )  ,  foldr ($) atacante (elementosDeDefensa (elementos defensor)  ) )
                                defensor                                      atacante  

elementosDeAtaque :: [Elemento] -> [(Personaje-> Personaje)] 
elementosDeAtaque elementos = map ataque elementos

elementosDeDefensa :: [Elemento] -> [(Personaje-> Personaje)] 
elementosDeDefensa elementos = map defensa elementos

estaMuerto:: Personaje -> Bool
estaMuerto personaje = salud personaje == 0 -}



----------------------------------------------------------------
----------------------------PUNTO 5-----------------------------
----------------------------------------------------------------
f x y z
    | y 0 == z = map (fst.x z)
    | otherwise = map (snd.x (y 0))

--f :: (Eq t1, Num t2) =>
--     (t1 -> a1 -> (a2, a2)) -> (t2 -> t1) -> t1 -> [a1] -> [a2]