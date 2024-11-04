object prueba {}

class Cocinero {
    
    var especialidad


    method cocinar(){
        especialidad.cocinar()
    }

    method catar(plato){
        const puntaje = especialidad.catar(plato)
        const cocinero = plato.cocinero()
        plato.agregarCalificacion(puntaje)
}

    method participarDeUnTorneo() {
        const platoParticipante = especialidad.cocinar()
        torneo.unirseAlTorneo(platoParticipante)
        torneo.verificarGanador()
    }

    method cambiarDeEspecialidad(unaEspecialidad) {
		especialidad = unaEspecialidad
	} //ojo no lo habia puesto pero el enunciado pide "Que un cocinero pueda cambiar de especialidad "
}

class Pastelero{
    const nivelDeseadoDeDulzor

    method catar(plato) = (5 * plato.azucar() / nivelDeseadoDeDulzor).max(10)
    //chquear el max

    method cocinar() {
        const coloresPostre = nivelDeseadoDeDulzor/50
        const nuevoPostre = new Postre(colores = coloresPostre, cocinero = self)
        return nuevoPostre
    }
}

class Chef{
    const limiteDeCals

    method catar(plato) = if (self.cumpleLasExpectativas(plato)) 10 else 0

    method cumpleLasExpectativas(plato) = plato.esBonito() && plato.calorias() <= limiteDeCals

    method cocinar() {
        const azucarPrincipal = limiteDeCals
        const nuevoPrincipal = new Principal(azucar = azucarPrincipal, cocinero = self)
        return nuevoPrincipal
    }
}

class Souschef inherits Chef{
    override method catar(plato) = if (self.cumpleLasExpectativas(plato)) 10 else (plato.calorias()/100).max(6)
    //en chef podias poner como metodo nota mimina y aca hacer override de ese metodo solamente
    override method cocinar() {
        const nuevaEntrada = new Entrada(cocinero = self)
        return nuevaEntrada
    }
}


class Plato {
    const catadores = []
    const caloriasBase = 100
    const cocinero
    var puntajeActual = 0

    method puntaje() = puntajeActual
    method cocinero() = cocinero
    method azucar()
    method calorias() =  caloriasBase + 3 * self.azucar() 

    method agregarCalificacion(puntaje) {
        puntajeActual += puntaje
    }

}

class Entrada inherits Plato {
    method esBonito() = true
    override method azucar() = 0
}

class Principal inherits Plato {
    const azucar

    method esBonito(){
    }
    
    override method azucar() = azucar
}

class Postre inherits Plato {
    const colores
    override method azucar() = 120
    method esBonito() = colores > 3
}

object torneo {
    var platosParticipantes = []

    method verificarGanador(){
        if(self.hayParticipantes()){
            const platoGanador = platosParticipantes.max{ pp => pp.puntaje() } 
            return platoGanador.cocinero()
        }
        else{
            self.error("No se puede establecer el ganador")
        }
    }

    method hayParticipantes() = !platosParticipantes.isEmpty()

    method unirseAlTorneo(platoParticipante) {
        platosParticipantes.add(platoParticipante)
    }
}
