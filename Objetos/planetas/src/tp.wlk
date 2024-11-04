object prueba {}

class Persona {
    var recursos = 20
    var edad = 0

    method ganarMonedas(monedasGanadas) {
        recursos += monedasGanadas
    }

    method perderMonedas(monedasPerdidas) {
        recursos -= monedasPerdidas
    }

    method recursos() = recursos 

    method esDestacada() = self.edadEntre(18, 65) || self.masDeXRecursos(30)  

    method edadEntre(min,max) = edad > min && edad < max // self.between(unaEdadMinimo, unaEdadMaximo)
    method masDeXRecursos(parametro) = recursos > parametro 

    method cumplirAnios() {
        edad += 1  //aniosActuales++
    }

    method trabajar(unPlaneta, unUnidadDeTiempo) {} // eso hay que ponerlo porque el enunciado dice "Para las personas que no son ni constructoras ni productoras, trabajar no les afecta ni altera el planeta"
}

class Construccion {
    method valor() 
}

class Muralla inherits Construccion {
    const longitud = 0
    override method valor() = 10 * longitud
}

class Museo inherits Construccion {
    const superficieCubierta = 0
    const indiceDeImportancia = 0
    override method valor() = (superficieCubierta * indiceDeImportancia).limitBetween(1,5)
}

class Planeta {
    var habitantes = []
    var construcciones = []

    method construcciones() = construcciones 
    method habitantes() = habitantes 


    method delegacionDiplomatica() {
        const delegacionDiplomatica = self.habitantesDestacados()
        delegacionDiplomatica.add(self.habitanteConMasRecursos())
        return delegacionDiplomatica
    }

    method habitanteConMasRecursos() = habitantes.max{ h => h.recursos() }
    method habitantesDestacados() = habitantes.filter{ h => h.esDectacada() } 

    method esValioso() = self.valorDeLasConstruccionesMayorA(100)

    method valorDeLasConstruccionesMayorA(valor) = construcciones.sum { c => c.valor() } > valor
}


class Productor inherits Persona {
    var tecnicas = [cultivo]
    
    method cantidadDeTecnicas() = tecnicas.size()

    override method recursos() = super() * self.cantidadDeTecnicas()
    
    override method esDestacada() = super() || self.cantidadDeTecnicas() > 5

    method realizarUnaTecnica(tecnica,cantidadDeTiempo) {
    if(tecnicas.contains(tecnica)){
        self.ganarMonedas(3*cantidadDeTiempo)
    }
    else{
        self.perderMonedas(1)
    }
    }

    method aprenderUnaTecnica(nuevaTecnica) {
        tecnicas.add(nuevaTecnica)
    }

    override method trabajar(planeta,cantidadDeTiempo) {
        if(planeta.habitantes().contains(self)){
            const ultimaTecnicaAprendida = tecnicas.last()
            self.realizarUnaTecnica(ultimaTecnicaAprendida, cantidadDeTiempo)
        }
        else{
            self.error("El productor no vive en ese planeta")
        }
            }
}

object cultivo {
}

class Constructor inherits Persona {
    const construccionesRealizadas = []
    const region 

    method cantidadDeConstruccionesRealizadas() = construccionesRealizadas.size()

    override method recursos() = super() + 10 * self.cantidadDeConstruccionesRealizadas()

    override method esDestacada() = self.cantidadDeConstruccionesRealizadas() > 5

    override method trabajar(planeta,cantidadDeTiempo) {
        const construccion = region.trabajar(planeta, cantidadDeTiempo, self)
        planeta.construcciones().add(construccion)
        self.perderMonedas(5)
        construccionesRealizadas.add(construccion)
    }
}

object montania {
    method trabajar(planeta,cantidadDeTiempo,construc) = new Muralla( longitud = cantidadDeTiempo / 2 )

}

object costa {
    method trabajar(planeta,cantidadDeTiempo,construc) = new Museo( superficieCubierta = cantidadDeTiempo, indiceDeImportancia = 1 )
}

object llanura {
    method trabajar(planeta,cantidadDeTiempo,construc) {
        if(construc.esDestacada()){
            const indice = construc.recursos() //ver abajo
            return new Museo(superficieCubierta = cantidadDeTiempo, indiceDeImportancia = indice) //ver abajo
        }
        else{
            montania.trabajar(planeta, cantidadDeTiempo, construc)
        }
    }
}

/*
el enunciado decia:

En la resolucion esta asi:
const indiceDeImportancia = new Range(start = 1, end = unosRecursos).anyOne()
			if(indiceDeImportancia > 5)
				throw new UserException(message = "No se pueden crear un Museo con indice mayor a 5!")
			else
				return new Museo(superficieOcupada = unaUnidadDeTiempo, indiceDeImportancia = indiceDeImportancia))
		}
*/