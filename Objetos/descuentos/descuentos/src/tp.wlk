object prueba {}

/*link https://www.utnianos.com.ar/foro/attachment.php?aid=22368*/

object plataforma {
    var juegos = []

    method juegoMasCaro() = juegos.max{j => j.precio()} //devuelve el juego
    method precioJuegoMasCaro() = self.juegoMasCaro().precio() // buscamos el precio de ese juego

    method cambiarDescuentoDelJuego(juego,nuevoDescuento) {
        juego.cambiarDescuento(nuevoDescuento)
    }

    method superaTresCuartosDelPrecioMasCaro(juego) = juego.precio()> (self.precioJuegoMasCaro() * 0.75)
    method listaADescontar() = juegos.filter { j => self.superaTresCuartosDelPrecioMasCaro(j) }
    method aplicarDescuentosPorcentual(nuevoPorcentaje) {
        if (nuevoPorcentaje > 100)
	 	{
	 		self.error("No se puede aplicar un descuento del mas del 100%")
	 	}
        const nuevoDesc = new DescuentoDirecto(porcentaje = nuevoPorcentaje)
        self.listaADescontar().forEach{j => j.cambiarDescuento(nuevoDesc)}      
    }

    method juegosAptos(pais) = juegos.filter { j => j.esApto(pais) }
    method precioJuegosAptos(pais) = self.juegosAptos(pais).sum { j => j.precio() }
    method promedioFinalJuegosAptos(pais) = pais.convertir(self.precioJuegosAptos(pais)) / (self.juegosAptos(pais).size()) 
}

class Juego{
    var tipoDescuento
    var precioBase
    var caracteristicas = []
    var criticas = []

    method precio() = (tipoDescuento.aplicar(precioBase)).max(0)

    method cambiarDescuento(nuevoDesc) {
        tipoDescuento = nuevoDesc
    }

    method esApto(pais) = !(caracteristicas.any{c => pais.caracteristicasProhibidas().contains(c)} )

    /*
    Tambien podrias verificar que las prohibidas una por una no esten en las caracteristicas
    opcion larga:
    method contieneCaracteristica(caracteristica){
		return caracteristicas.contains(caracteristica)
	}
	
	method contieneAlgunaCaracteristica(listaCaracteristicas) {
		return listaCaracteristicas.any{x => self.contieneCaracteristica(x)}
	}
	method aptoParaMenoresEnPais(pais)
	{
		return !self.contieneAlgunaCaracteristica(pais.caracteristicasProhibidas())
	}
*/

    method criticar(critica) {
        criticas.add(critica)
    }

}

class DescuentoDirecto{

    var porcentaje = 0
    method aplicar(precioBase){
        return precioBase - precioBase * porcentaje/100
    }
}

class DescuentoFijo {
    var montoFijo = 0

    method aplicar(precioBase) {
        return precioBase - montoFijo   
    }

}

object gratis {

    method aplicar(precioBase) {
        return precioBase   
    }

}

class Pais{
    const conversion
    var caracteristicasProhibidas = []

    method caracteristicasProhibidas() = caracteristicasProhibidas 
    method convertir(precioEnUSD) = precioEnUSD * conversion
}

//aca tnedrias que haber hecho un class critico y estos heredan y sobrescriben el esPositiva, porque comprarten el metodo criticar excepto el utimo que agrega una cosita mas
class Usuario{

    method criticar(juego) {
        const critica
        juego.criticar(critica)
    }

    method esPositiva(critica,juego) = critica == "SI"
}

class CriticoPago{
    var juegosQueLePagaron = []

    method recibirPago(juego) {
        juegosQueLePagaron.add(juego)
    }

    method dejarDeRecibirPagoDeJuego(juego)
	{
		juegosQueLePagaron.remove(juego)
	}

    method criticar(juego) {
    const critica
        juego.criticar(critica)
    }

    method esPositiva(critica,juego) = juegosQueLePagaron.contains(juego)
}

class Revista{
    var criticos = []

    method criticar(juego) {
        const criticaConcatenada = juego.criticas().join(" ") //aca obtenemos una lista con todas las criticas de los criticos a ese juego, para luego agregarla como una sola critica
        juego.criticar(criticaConcatenada)
    }

    method esPositiva(critica,juego) = self.cantCriticosQueCalificaronPositivamente(critica, juego) >= self.mayoriaDeCriticos()
    
    method mayoriaDeCriticos() = criticos.size() / 2 + 1 
    method cantCriticosQueCalificaronPositivamente(critica,juego) = criticos.filter {c => c.esPositiva(critica,juego)}.size()

// Una revista puede incorporar o perder críticos.
	method incorporarCritico(critico)
	{
		criticos.add(critico)
	}
	
	method removerCritico(critico)
	{
		criticos.remove(critico)
	}

}

/*Esta mal habria que haber hecho algo asi
class Critica {
	var property texto
	
	method esPositiva() 

}


*/