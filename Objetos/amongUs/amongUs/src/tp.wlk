object prueba {}

//enunciado:https://docs.google.com/document/d/11YZQWd0RiAEKgij7ME3641xl5j1oL7_SBLxbpb2AwVw/edit?tab=t.0
//solucion: https://github.com/GonGarciaFontenla/PdeP/blob/main/Wollok/Parciales/Among%20Us/example.wlk#L167


object nave {
    var jugadores = []
    var nivelDeOxigeno = 0
    var cantidadDeTripulantes = 0 //el enuenciado dice que esto no tenemos que tenerlo en cuenta, antes habia hecho variable tipo y hacia filter de la lista jugadores, pero no es necesario
    var cantidadDeImpostores = 0
    
    method jugadores() = jugadores



    method tareaRealizada(tarea) {
        if(self.ganaronElJuego())
        {
            self.error("Crews wins") // throw new DomainException(message = "Ganaron los tripulantes")
        }
    }

    method ganaronElJuego() = jugadores.all{ j => j.completoSusTareas() }

    method modificarNivelDeOxigeno(nuevoNivel) {
        nivelDeOxigeno = nivelDeOxigeno + nuevoNivel
        if(nivelDeOxigeno<1){
            self.error("Impostors wins")
        }
    }

    method alguienTiene(item) = jugadores.any{ j => j.tiene(item) } 

    method jugadorConMayorNivelDeSospecha() = jugadores.max{ j => j.nivelDeSospecha() } //CLAVE : devuelve el jugador con mayor nivel de sospecha

    method jugadorConMasVotos() =  jugadores.max{ j => j.cantidadDeVotos() } //devuelve el jugador con mas votos

    method mayoresVotos() = self.jugadorConMasVotos().cantidadDeVotos() //devuelve la cantidad de votos de ese jugador


    method llamarAUnaReunionDeEmergencia() { //antes habia puesto esto en jugador pero no tiene sentido porque la mayoria se hace ACA en la nave
    if(self.mayoresVotos()> votosEnBlanco.cantidad()){
        const expulsado = self.jugadorConMasVotos()
        expulsado.expulsar() // si es tripulante se va a su propio metodo y si es impostor se va a su propio metodo
        self.chequearSiAlguienGano()
        //ojo no hay que eliminar al jugador porque puede seguir haciendo tareas
    }
    }

    method chequearSiAlguienGano() {
        if(cantidadDeImpostores == 0){
            self.error("Crews wins")
        }
        else if(cantidadDeImpostores == cantidadDeTripulantes){
            self.error("Impostors wins")
        }
    }

/*otra opcion para buscar el mas votado:
const losVotitos = self.jugadoresVivos().map { jugador => jugador.voto() }
ahi crea una lista de todos votos de los jugadores (o sea crea una lista de jugadores votados)
const elMasVotado = losVotitos.max { alguien => losVotitos.occurrencesOf(alguien) }
aqui busca el jugador que mas ocurrencias tenga
La diferencia es que yo hice que cada jugador tenga un contador de cuantos lo votaron, asi encontre al mas votado
*/


    method expulsarTripulante() {
    cantidadDeTripulantes -= 1
    }

    method expulsarImpostor() {
        cantidadDeImpostores -= 1
    }
    
}

class Jugador {
    const color
    const mochila = []
    var nivelDeSospecha = 40
    var tareas = []
    var cantidadDeVotos
    var impugnado = false
    var vivo = true

    method impugnar() {
        impugnado = true      
    }

    method morir() {
    vivo = false
    }

    method estoyVivo() = vivo

    method nivelDeSospecha() = nivelDeSospecha 

    method modificarNivelDeSospecha(nuevaSospecha){
        nivelDeSospecha = (nivelDeSospecha + nuevaSospecha).max(40)
    }
    
    method esSospechoso() = nivelDeSospecha > 50
    method noEsSospechoso() = !(self.esSospechoso())

    method buscarItem(item) {
        mochila.add(item)
    }

    method usarItem(item) {
        mochila.remove(item)
    }

    method hacerTarea()

    method completoSusTareas() 

    method tiene(item) = mochila.contains(item)

    method puedeVotar() = vivo && (!impugnado)

    method votar()  

    method agregarUnVoto() {
    cantidadDeVotos =+ 1
    }

    method cantidadDeVotos() = cantidadDeVotos 

    method tieneMochilaVacia() = mochila.isEmpty()

    method votarEnBlanco() {
        votosEnBlanco.agregarUnVoto()
        impugnado = false
    }

    method llamarAUnaReunionDeEmergencia() {
        nave.llamarAUnaReunionDeEmergencia() //delegamos
    }


}

class Tripulante inherits Jugador {
    var personalidad


    override method completoSusTareas() = tareas == [] //tareas.isEmpty()
    

    override method hacerTarea(){
        const tarea = tareas.find {t => t.puedeHacerLaTarea(self)}
        tarea.hacer(self)
        nave.tareaRealizada(tarea)
        tareas.remove(tarea)
} 

    override method votar(){
        if(self.puedeVotar()){
        personalidad.votar(self)
        }
        else{
            self.votarEnBlanco()
        }
    }

    method expulsar() {
        nave.expulsarTripulante()
        self.morir()
    }

}

class Impostor inherits Jugador {


    override method completoSusTareas() = true


    method realizarTarea() { //ojo! ponerlo
    // No hace nada
    }
    method realizarSabotaje(sabotaje) {
        sabotaje.hacer() //aca no lleva parametros entonces en los objects tampoco
        self.modificarNivelDeSospecha(5)
    }

    override method votar() {
        if(self.puedeVotar())
        {
            const votado = nave.jugadores().anyOne()
            votado.agregarUnVoto()
        }
    
    }

    method expulsar() {
    nave.expulsarImpostor()
    self.morir()
    }

}

//las tareas habia que hacerlas con clases porque hay repeticion de logica en verificar si puede hacerla, luego sacar los items necesario y afectar a la persona
object arreglarElTableroElectrico {
    const elementosNecesarios = ["Llave inglesa"]
    method puedeHacerLaTarea(jugador) = elementosNecesarios.all{e => jugador.tiene(e)}
    method hacer(jugador) {
        if(self.puedeHacerLaTarea(jugador)){
            jugador.modificarNivelDeSospecha(10)
            elementosNecesarios.forEach{e => jugador.usarItem(e)}
        }
}
}

object sacarLaBasura {

    const elementosNecesarios = ["Bolsa de Consorcio", "Escoba"]

    method puedeHacerLaTarea(jugador) = elementosNecesarios.all{e => jugador.tiene(e)}


    method hacer(jugador) {
    if(self.puedeHacerLaTarea(jugador)){
        jugador.modificarNivelDeSospecha(-4)
    }
}
}

object ventilarLaNave {
    
    method puedeHacerLaTarea(jugador) = true

    method hacer(jugador) {
    if(self.puedeHacerLaTarea(jugador)){
        nave.modificarNivelDeOxigeno(5)
    }
}
}

object reducirOxigeno {

    method puedeHacer() = !(nave.alguienTiene("Tubo De Oxigeno"))

    method hacer() {
        if(self.puedeHacer()){
            nave.modificarNivelDeOxigeno(-10)
        }
    }
}

class ImpugnarAUnJugador {
    
    const jugador

    method hacer() { //si no haces clase, tendrias que pasarle un parametro jugador y ya no hay polimorismo cuando desde arriba llamas sabotaje.hacer()
        jugador.impugnar()
    }
}


//Es mas correcto que en troll y materialista hagas como en detective de pedirle a la nave que te pase ese jugador y que la nave tenga ese metodo y lo devuelva, no vos desde aca
object troll {
    method votar(jugador) {
        const votado = nave.jugadores().find({j => j.noEsSospechoso()})
        if(votado != null){  //esto esta mal porque no devuelve null, tira una excepcion asi que hay que cambiarlo por findOrDefault!!!
        votado.agregarUnVoto()
        }
        else{
            jugador.votarEnBlanco()
        }
    }
}

object detective {
    method votar(jugador) {
        const votado = nave.jugadorConMayorNivelDeSospecha()
        votado.agregarUnVoto()
    }
}

object materialista {
    method votar(jugador) {
        const votado = nave.jugadores().find({j => j.tieneMochilaVacia()})
        if(votado != null){
        votado.agregarUnVoto()
        }
        else{
            jugador.votarEnBlanco()
        }
    }
}

object votosEnBlanco {
    var cantidad = 0
    method agregarUnVoto() {
    cantidad =+ 1
    }
    method cantidad() = cantidad
}