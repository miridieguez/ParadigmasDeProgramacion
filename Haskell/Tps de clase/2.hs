module Library where
import PdePreludat
import Control.Concurrent (yield)

-- 1. Mas numeros!

-- **max** toma dos valores como parámetro y nos devuelve aquel que sea mas grande
-- **min** toma lo mismo que max pero nos devuelve el que sea mas chico.

max' :: Number -> Number -> Number
max' n1 n2
    | n1 == n2 = n1 --si son iguales, da igual cual se devuelve
    | n1 < n2 = n2 
    | otherwise = n1

min' :: Number -> Number -> Number
min' n1 n2
    | n1 == n2 = n1 
    | n1 < n2 = n1 
    | otherwise = n2

-- 1.5 Bonus OPCIONAL
cuantosDiasTiene :: Number -> Number
cuantosDiasTiene anio
    | mod anio 400 == 0 || (mod anio 4 == 0 && mod anio 100 /= 0)  = 366
    | otherwise = 365
-- Un año es bisiesto si es divisible por 400 o
-- si es divisible por 4 pero no por 100.

descuentoMenor :: Number
descuentoMenor = 0.9

descuentoMayor :: Number
descuentoMayor = 0.7

precioTotal :: Number -> Number -> Number
precioTotal valorUnitario cantidad
    | cantidad < 3 = valorUnitario * cantidad 
    | cantidad >= 3 && cantidad < 10 = valorUnitario * cantidad * descuentoMenor 
    | otherwise = valorUnitario * cantidad * descuentoMayor

-- 2. Pinos

pesoPino :: Number -> Number --Recibe la altura de un pino en metros y devuelve su peso.
pesoPino altura
    | altura <= 3 = altura * 300
    | altura > 3 = 900 + (altura - 3) * 200

pesoMax :: Number
pesoMax = 1000 --Peso en kg maximo que le sirve a la fabrica
pesoMin :: Number
pesoMin = 400 --Peso en kg minimo que le sirve a la fabrica

esPesoUtil :: Number -> Bool --Recibe un peso en kg y responde si un pino de ese peso le sirve a la fábrica
esPesoUtil peso
    | peso <= pesoMax && peso >= pesoMin = True
    | otherwise = False

sirvePino :: Number -> Bool --Recibe la altura de un pino y responde si un pino de ese peso le sirve a la fábrica.
sirvePino altura
    | esPesoUtil (pesoPino altura) = True
    | otherwise = False
