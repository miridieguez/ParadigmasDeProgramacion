
--FALTAN LOS TEST

{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use map" #-}
{-# HLINT ignore "Use null" #-}
{-# HLINT ignore "Use foldr" #-}
module Library where
import PdePreludat

data Color = Rojo | Verde | Amarillo | Azul deriving(Show,Eq)
data Simbolo = Reversa | Mas4 | SaltarTurno deriving (Eq, Show)

data Carta =
    CartaNumerica { numero :: Number, color :: Color } |
    CartaEspecial { simbolo :: Simbolo, color :: Color }
    deriving (Eq, Show)

fibonacci :: Number -> Number
fibonacci 1 = 0 
fibonacci 2 = 1
fibonacci unNumero = fibonacci(unNumero-1) + fibonacci(unNumero-2)
 

rellenar :: [Char] -> Number -> Char -> [Char]
rellenar unaPalabra unaLongitud unCaracter
    | length unaPalabra >= unaLongitud = unaPalabra
    | otherwise = rellenar (unaPalabra ++ [unCaracter]) unaLongitud unCaracter

dividir :: Number -> Number -> Number
dividir dividendo divisor 
    | dividendo < divisor = 0
    | dividendo >= divisor = 1 + dividir (dividendo-divisor) divisor


ultimaCarta :: [Carta] -> Carta
ultimaCarta [x] = x
ultimaCarta (x:xs) = ultimaCarta xs


primeras :: Number -> [a] -> [a]
primeras unNumero (x:xs)  
      |  unNumero == 0 = []
      | otherwise = x: primeras (unNumero-1) xs
   

cartasAColores :: [Carta] -> [Color]
cartasAColores [] = []
cartasAColores (x:xs) = color x : cartasAColores xs


obtenerElemento :: Number -> [a] -> a
obtenerElemento 0 (x:xs) = x 
obtenerElemento unNumero (x:xs) = obtenerElemento (unNumero-1) xs


sacarHastaEncontrar :: Carta -> [Carta] -> [Carta]
sacarHastaEncontrar unaCarta (x:xs)
      | xs == [] = [x]
      | x == unaCarta = [x]
      | otherwise = x: sacarHastaEncontrar unaCarta xs

lasRojas :: [Carta] -> [Carta]
lasRojas [] = []
lasRojas (x:xs)
      | color x == Rojo = x: lasRojas xs
      | otherwise = lasRojas xs

lasQueSonDeColor ::  Color -> [Carta] -> [Carta]
lasQueSonDeColor unColor [] = []
lasQueSonDeColor unColor (x:xs)
      | color x == unColor = x: lasQueSonDeColor unColor xs
      | otherwise = lasQueSonDeColor unColor xs

lasFiguras :: [Carta] -> [Carta]
lasFiguras [] = []
lasFiguras (CartaEspecial simbolo color : xs) = CartaEspecial simbolo color : lasFiguras xs
lasFiguras (CartaNumerica num color : xs) = lasFiguras xs --VOLVER A MIRAR, nunca entendi

-- **sumatoria**: dado una lista de números, los suma. Si la lista está vacía devuelve 0. 
sumatoria :: [Number] -> Number
sumatoria [] = 0
sumatoria (x:xs) = x + sumatoria xs
