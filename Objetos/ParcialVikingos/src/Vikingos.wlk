class Vikingo {
	var casta
	var empleo
	var armas = 0
	var cantidadDeHijos = 0

	method puedeIrAExpedicion(expedicion) = empleo.esProductivo(self) && casta.puedeIrAExpedicion(self)
	method tieneArmas() = armas > 0
	method noTieneArmas() = !(self.tieneArmas())
	method cantidadDeHijos() = cantidadDeHijos 

	method ascenderaKarl() {
		casta = new Karl()
		empleo.ascenderAKarl(self)
	}

	method agregarArmas(cantidad) {
		armas += cantidad
	}

	method agregarHijos(cantidad) {
		cantidadDeHijos += cantidad
	}

	method irAExpedicion(expedicion) {
		if(self.puedeIrAExpedicion(expedicion)){
			expedicion.ir(self)
		}
	}

	method matar() {
		empleo.cobrarVida()
	} 

}

class Expedicion {
	var vikingos = #{}
	var defensores = #{}

	method vikingos() = vikingos
	method defensores() = defensores 
	method ir()
	method valeLaPena() 
}
class InvasionDeUnaCapital inherits Expedicion {
	const capital
	var defensoresDerrotados

	var botinConseguido = defensoresDerrotados * capital.factorDeRiqueza()
	method cantidadDeVikingos() = self.vikingos().size()

	override method valeLaPena() = botinConseguido == 3* self.cantidadDeVikingos()


	override method ir(){
		self.defensores().forEach{d => d.matar() }
	}
}

class InvasionDeAldeas inherits Expedicion {
	const aldeas = #{}
	var defensoresDerrotados
	
	method aldeas() = aldeas 
	var botinConseguido = self.aldeas().sum{ a => a.cantidadDeCrucifijos() } 

	override method valeLaPena() = self.aldeas().all { a => a.cantidadDeCrucifijos() >= 15}

	override method ir(){
		self.aldeas().forEach{a => a.robarCrucifijos() }
	}
}

object soldado {
	var vidasCobradas = 0

	method esProductivo(persona) = vidasCobradas > 20 && persona.tieneArmas()

	method ascenderAKarl(persona) {
		persona.agregarArmas(10)
	}

	method cobrarVida() {
		vidasCobradas +=1
	}
} 
object granjero {
	var hectareasPorHijo = 0

	method esProductivo(persona) = hectareasPorHijo > 2 * persona.cantidadDeHijos()
	method ascenderAKarl(persona) {
		persona.agregarHijos(1)
		hectareasPorHijo += 2
	}
}

class Jarl { //esclavo
	method puedeIrAExpedicion(persona,expedicion) =  persona.noTieneArmas()

	method convertirseAKarl() {
	}
}

class Karl { //casta media
	method puedeIrAExpedicion(persona) =  persona.noTieneArmas()

	method convertirseAKarl() {
	}
}