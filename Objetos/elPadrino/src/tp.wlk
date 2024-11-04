object prueba {}

class Persona {
    var rango = new Soldado()
    var armasConocidas = [new Escopeta()]
    var duermeConPeces = true
    var estoyMuerto = false
    var lealtad = 0
    var familia = new Familia(don=new Don())

    method aumentarLealtad(porcentaje) {
        lealtad + lealtad * porcentaje/100
    }
    method nuevaFamilia(r) {
        familia = new Familia(don=new Don(), integrantes=[r])
    }

    method abandonarFamilia() {
        familia = null
    }

    method familia() = familia

    method sabeDespacharElegantemente() = self.rango().sabeDespacharElegantemente() 


    method lealtad() = lealtad
    method rango() = rango

    method usarArma(atacante, victima) {
        rango.usarArma(self, victima)
    }

    method duermeConPeces() = estoyMuerto

    method morir() {
        estoyMuerto = true
    }

    method estoyVivo() =  !estoyMuerto

    method nombrarSubjefe() {
        rango = new Subjefe(subordinados = #{})
    }

    method nombrarDon() {
        rango = new Don(subordinados = self.rango().subordinados())
    }

}
class Don {
    var subordinados = #{}
    var armasQueTiene = [new Revolver(balas=6)]

    method subordinados() = subordinados 
    method armasQueTiene() = armasQueTiene 

    method usarArma(atacante, victima) {
        const subordElegido = subordinados.anyOne()
        self.ordenarataque(subordElegido, victima)
    }

    method ordenarataque(atacante,victima) {
        atacante.rango().usarArma(atacante,victima)
        atacante.rango().usarArma(atacante,victima)
    }

    method sabeDespacharElegantemente() = true 

    method esSoldado() = false

}

class Subjefe {
    var armasQueTiene = [new Revolver(balas=6)]
    var subordinados = #{}
    method subordinados() = subordinados 


    method armasQueTiene() = armasQueTiene 
    method cantidadDeArmas() = armasQueTiene.size()

    method usarArma(atacante, victima) {
        const armaAUSar = armasQueTiene.anyOne()
        armaAUSar.usarArma(victima)
    }

    method sabeDespacharElegantemente() = subordinados.any{ s => s.tieneArmaSutil() } 

    method tieneArmaSutil() = armasQueTiene.any{ a => a.armaSutil() }

    method esSoldado() = false

}

class Soldado {
    var armasQueTiene = [new Escopeta(),new Revolver(balas=6)]
    
    method armasQueTiene() = armasQueTiene 
    method cantidadDeArmas() = armasQueTiene.size()

    method usarArma(atacante, victima) {
        const armaAUSar = armasQueTiene.first()
        armaAUSar.usarArma(victima)
    }

    method obtenerArma(nuevaArma) {
        armasQueTiene.add(nuevaArma)
    }

    method tieneArmaSutil() = armasQueTiene.any{ a => a.armaSutil() }
    
    method sabeDespacharElegantemente() = self.tieneArmaSutil() 

    method esSoldado() = true


}

class Revolver {
    var balas = 6

    method usarArma(victima) {
    if(self.tengoBalas()){
        victima.morir() 
        self.gastarUnaBala()
    }
    }

    method tengoBalas() = balas > 0 

    method gastarUnaBala() {
        balas = balas + 1
    }

    method armaSutil() = balas == 1
}

class Escopeta {
    method usarArma(victima) {
    if(victima.herida()){
        victima.morir()
    }
    else{
        victima.darTiempo()
        victima.herir()
    }
    }

    method armaSutil() = false

}

class CuerdaDePiano {
    var buenaCalidad = true

    method buenaCalidad() = buenaCalidad 

    method usarArma(victima) {
    if(self.buenaCalidad()){
        victima.morir()
    }
    }
    method armaSutil() = true
}

class Familia {

    var don 
    var integrantes = []
    var integrantesVivos = integrantes.filter{ i => i.estoyVivo()  }
    var soldadosConMasDe5Armas = integrantesVivos.filter{ i => i.rango().esSoldado() && i.rango().cantidadDeArmas() > 5 }
    var traiciones = []

    method integrantesVivos() = integrantesVivos
    method traiciones() = traiciones 
    method integrantes() = integrantes
    method masPeligroso() = integrantesVivos.max{ i => i.rango().cantidadDeArmas() }
    method masLeal(muerto) = muerto.subordinados().max{ i => i.lealtad() }

    method atacarAOtraFlia(familiaAtacada) {
        const victima = familiaAtacada.masPeligroso()
        if(victima.estoyVivo()){
            integrantesVivos.forEach{ i => i.usarArma(i, victima)}
        }
    }

    method reorganizarse(muerto) {
    soldadosConMasDe5Armas.foreach{ s => s.nombrarSubjefe() }
    const nuevoDon = self.masLeal(muerto)
    if(nuevoDon.sabeDespacharElegantemente()){
        nuevoDon.nombrarDon()
        don = nuevoDon
    }
    integrantesVivos.forEach{ i => i.aumentarLealtad(10) }
    }

    method lealtadPromedio() = self.sumaLealtades() / integrantesVivos.size()

    method sumaLealtades() = integrantesVivos.sum{ i => i.lealtad() }
}

class Traicion {
    var victimasElegidas = #{}
    var fechaTentativa = 0
    var traidor

    method agregarVictima(nuevaVictima){
        victimasElegidas.add(nuevaVictima)
    }

    method adelantarTraicion(nuevaVictima,diasAgregados) {
        self.agregarVictima(nuevaVictima)
        self.adelantarFecha(diasAgregados)
    }

    method adelantarFecha(cantidadDeDias) {
        fechaTentativa =+ cantidadDeDias
    }

    method intentarRealizarTraicion() {
        traidor.familia().traiciones().add(self)
        if(traidor.familia().lealtadPromedio() > (traidor.lealtad() * 2)){
            traidor.ajusticiar()
        }
        else{
            self.concretarTraicion()
        }
    }

    method concretarTraicion() {
        victimasElegidas.forEach { v => traidor.usarArma(self, v)}
        traidor.abandonarFamilia()
        traidor.nuevaFamilia(new Soldado())
    }
}