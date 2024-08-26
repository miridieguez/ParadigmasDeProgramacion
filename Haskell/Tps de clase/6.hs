{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant lambda" #-}
{-# HLINT ignore "Redundant bracket" #-}
module Library where
import PdePreludat
--import Library (Ingrediente(PanIntegral))

data Ingrediente =
    Carne | Pan | Panceta | Cheddar | Pollo | Curry | QuesoDeAlmendras | Papas | PatiVegano | PanIntegral
    deriving (Eq, Show)

precioIngrediente Carne = 20
precioIngrediente Pan = 2
precioIngrediente Panceta = 10
precioIngrediente Cheddar = 10
precioIngrediente Pollo =  10
precioIngrediente Curry = 5
precioIngrediente QuesoDeAlmendras = 15
precioIngrediente Papas = 10
precioIngrediente PatiVegano = 10
precioIngrediente PanIntegral = 3


data Hamburguesa = Hamburguesa {
    precioBase :: Number,
    ingredientes :: [Ingrediente],
    precioFinal :: Number
} deriving (Eq, Show)

cuartoDeLibra = Hamburguesa {
    precioBase = 20,
    ingredientes = [Pan, Carne, Cheddar, Pan],
    precioFinal = precio cuartoDeLibra
}

-- **Agrandar**: cada vez que se agranda una hamburguesa se agrega otro ingrediente base (Carne | Pollo), se elige el ingrediente base a agregar según lo que ya haya en la hamburguesa (si había carne se agrega carne, si había pollo se agrega pollo, si había ambos da igual cual se agregue).
agrandar :: Hamburguesa -> Hamburguesa
agrandar unaHamburguesa
  |  buscarIngrediente Carne unaHamburguesa = agregarIngrediente Carne unaHamburguesa
  |  buscarIngrediente Pollo unaHamburguesa = agregarIngrediente Pollo unaHamburguesa

-- **AgregarIngrediente**: recibe un ingrediente y una hambrugesa lo agrega a la hamburguesa.
agregarIngrediente :: Ingrediente -> Hamburguesa -> Hamburguesa
agregarIngrediente unIngrediente unaHamburguesa = unaHamburguesa { ingredientes = unIngrediente : ingredientes unaHamburguesa }

buscarIngrediente :: Ingrediente -> Hamburguesa -> Bool
buscarIngrediente unIngrediente (Hamburguesa precioBase [] precioFinal ) = False
buscarIngrediente unIngrediente (Hamburguesa precioBase (x:xs) precioFinal )
    | x == unIngrediente = True
    | otherwise = buscarIngrediente unIngrediente (Hamburguesa precioBase xs precioFinal )

-- **descuento**: recibe un % de descuento, y devuelve la hamburguesa con ese descuento aplicado al precio base.
descuento :: Number -> Hamburguesa -> Hamburguesa
descuento unDescuento unaHamburguesa = unaHamburguesa { precioBase = precioBase unaHamburguesa - precioBase unaHamburguesa * unDescuento/100 }

--calculo del precio final (solo para las burguers sin descuento)
precio :: Hamburguesa -> Number
precio (Hamburguesa precioBase [] precioFinal ) = precioBase 
precio (Hamburguesa precioBase (x:xs) precioFinal ) = precioIngrediente x + precio (Hamburguesa precioBase xs precioFinal ) 


--la pdepBurguer que es un cuarto de libra agrandado 2 veces con panceta, cheddar y 20% de descuento. 
--Su precio final deberia ser 110
pdepBurguer = Hamburguesa {
   precioBase = precioBase (descuento 20 cuartoDeLibra),
   ingredientes = ingredientes ((agrandar . agrandar . agregarIngrediente Cheddar . agregarIngrediente Panceta) cuartoDeLibra),
   precioFinal = precio pdepBurguer
}

-- PARTE 2: Algunas hamburguesas más

-- **dobleCuarto** = es un cuarto de libra con carne y cheddar. El precio final deberia ser 84.
dobleCuarto = Hamburguesa {
   precioBase = precioBase cuartoDeLibra,
   ingredientes = ingredientes ((agrandar . agregarIngrediente Cheddar) cuartoDeLibra),
   precioFinal = precio dobleCuarto
}
-- **bigPdep** =  es un doble cuarto con curry. El precio final deberia ser 89.
bigPdep = Hamburguesa {
   precioBase = precioBase dobleCuarto,
   ingredientes = ingredientes (agregarIngrediente Curry dobleCuarto),
   precioFinal = precio bigPdep
   --cuantodescuento = 0
}
-- **delDia** = es una promo que dada una hamburguesa, le agrega Papas y un descuento del 30%. 
--Por ej, podría pedir una big pdep del dia y debería ser como una big pdep (doble cuarto con curry)
 --pero con papas y el descuento del 30%. Por ejemplo una doble cuarto del dia deberia valer 88.
delDia :: Hamburguesa -> Hamburguesa
delDia unaHamburguesa = Hamburguesa {
   precioBase = precioBase (descuento 30 unaHamburguesa),
   ingredientes = ingredientes (agregarIngrediente Papas unaHamburguesa),
   precioFinal = precio (delDia unaHamburguesa)
}
    
-- PARTE 3: algunos cambios más 

-- **hacerVeggie** : cambia todos los ingredientes base que hayan en la hamburguesa por PatiVegano (ingrediente base tambien de precio 10), el cheddar lo cambia por queso de almendras 
--y luego elimina cualquier ingrediente que haya quedado que sea carnívoro 
-- (por ahora son ingredientes carnívoros la Carne, el Pollo y la Panceta).
hacerVeggie :: Hamburguesa -> Hamburguesa
hacerVeggie (Hamburguesa precioBase ingredientes precioFinal ) = (Hamburguesa precioBase ((eliminarCarnivoros . cambiarPati . cambiarQueso) ingredientes) precioFinal ) 

cambiarPati :: [Ingrediente] -> [Ingrediente]
cambiarPati [] = []
cambiarPati (x:xs) 
   | x == Carne || x == Pollo = PatiVegano : xs
   | otherwise = x: cambiarPati xs

cambiarQueso :: [Ingrediente] -> [Ingrediente]
cambiarQueso [] = []
cambiarQueso (x:xs) 
   | x == Cheddar = QuesoDeAlmendras : cambiarQueso xs
   | otherwise = x: cambiarQueso xs   

eliminarCarnivoros :: [Ingrediente] -> [Ingrediente]
eliminarCarnivoros [] = []
eliminarCarnivoros (x:xs)
   | x == Carne || x == Pollo || x == Panceta = eliminarCarnivoros xs
   | otherwise = x: eliminarCarnivoros xs


 -- **cambiarPanDePati** : cambia el Pan que haya en la hamburguesa por PanIntegral (ingrediente de precio 3).
cambiarPanDePati :: [Ingrediente] -> [Ingrediente]
cambiarPanDePati [] = []
cambiarPanDePati (x:xs) 
   | x == Pan = PanIntegral : cambiarPanDePati xs
   | otherwise = x: cambiarPanDePati xs   

-- hacer el **dobleCuartoVegano** que es un dobleCuarto veggie con pan integral.
dobleCuartoVegano = Hamburguesa {
   precioBase = precioBase dobleCuarto,
   ingredientes = (eliminarCarnivoros . cambiarPati . cambiarQueso . cambiarPanDePati) (ingredientes dobleCuarto),
   precioFinal = precio dobleCuartoVegano
}

--Otra forma para la primer funcion
--  |  Carne `elem` ingredientes unaHamburguesa = unaHamburguesa { ingredientes = Carne : ingredientes unaHamburguesa }
--  |  Pollo `elem` ingredientes unaHamburguesa = unaHamburguesa { ingredientes = Pollo : ingredientes unaHamburguesa }

  
