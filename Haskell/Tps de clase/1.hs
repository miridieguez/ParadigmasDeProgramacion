module Library where
import PdePreludat

-- 1. Numeros

siguiente :: Number -> Number
siguiente x = x + 1

esPositivo :: Number -> Bool
esPositivo x = x > 0

-- escriban el tipo de esta función
inversa :: Number -> Number
inversa n = 1/n

-- 2. Temperaturas

celsiusAFarenheit :: Number -> Number
celsiusAFarenheit celsius = celsius * 1.8 + 32

farenheitACelsius :: Number -> Number
farenheitACelsius farenheit = (farenheit - 32) / 1.8

temperaturaFrioCelsius :: Number
temperaturaFrioCelsius = 8

-- escriban el tipo de esta función
haceFrioCelsius :: Number -> Bool
haceFrioCelsius grados = grados < temperaturaFrioCelsius

-- escriban el tipo de esta función
haceFrioFarenheit :: Number -> Bool
haceFrioFarenheit grados = grados < farenheitACelsius (temperaturaFrioCelsius)

-- 2.5 Bonus OPCIONAL
perimetroCirculo :: Number -> Number
perimetroCirculo radio = radio * 2 * pi

perimetroCuadrado :: Number -> Number
perimetroCuadrado lado = lado * 4

superficieCuadrado :: Number -> Number
superficieCuadrado lado = lado * 2

superficieCubo :: Number -> Number
superficieCubo lado = lado ^ 2

superficieCilindro :: Number -> Number -> Number
superficieCilindro radio altura = 2 * pi * radio * altura
