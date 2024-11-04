object prueba {}

class Persona {
    var edad
    var plataQueQuiereGanar
    var carrerasQueQuiereEstudiar = #{}
    var lugaresQueQuiereViejar = #{}
    var hijos = 0
    var sueniosPendientes = []
    var sueniosCumplidos = []
    var carrerasQueEstudio = []
    var personalidad
    var felicidad

    method carrerasQueQuiereEstudiar() = carrerasQueQuiereEstudiar
    method lugaresQueQuiereViejar() = lugaresQueQuiereViejar
    method sueniosPendientes() = sueniosPendientes
    method sueniosCumplidos() = sueniosCumplidos
    method plataQueQuiereGanar() = plataQueQuiereGanar  
    method carrerasQueEstudio() = carrerasQueEstudio 

    method tieneHijos() = hijos > 0 
    method noTieneHijos() = !(self.tieneHijos())

    method cumplirSuenio(suenio) {
        if(suenio.puedeCumplir(self)){
            suenio.cumplir(self)
            sueniosPendientes.remove(suenio)
            sueniosCumplidos.add(suenio)
        }
        else{
            self.error("La persona no cumple los requisitos para cumplir el suenio")
        }
    }

    method carreraEstudiada(carreraNueva) {
        carrerasQueEstudio.add(carreraNueva)
        //carrerasQueQuiereEstudiar.remove(carreraNueva)
    }

    method nuevoHijo() {
        hijos += 1
    }

    method viajarA(lugar) {
    }

    method cumplirSuenioMasPreciado() {
        const suenio = personalidad.suenioMasPreciado(self)
        self.cumplirSuenio(suenio)
    }

    method suenioQueDaMasFelicidad() = sueniosPendientes.max{ s => s.felicidonios() } 
    method algunSuenio() = sueniosPendientes.anyOne() 
    method primerSuenio() = sueniosPendientes.first() 

    method esFeliz() = felicidad > self.felicidadDeSueniosPendientes()
    method felicidadDeSueniosPendientes() = sueniosPendientes.sum{ s => s.felicidonios() } 

    method esAmbiciosa() = self.sueniosConMasDe100Felicidonios() > 3
    method sueniosConMasDe100Felicidonios() = self.cantidadConMasDe100Felicidonios(sueniosCumplidos) + self.cantidadConMasDe100Felicidonios(sueniosPendientes)

    method cantidadConMasDe100Felicidonios(lista) = lista.filter{ s => s.felicidonios() > 100}.size() 

}

object realista {
    method suenioMasPreciado(persona) = persona.suenioQueDaMasFelicidad()
}

object alocado {
    method suenioMasPreciado(persona) = persona.algunSuenio()
}

object obsesivo {
    method suenioMasPreciado(persona) = persona.primerSuenio()
}

class Suenio {
    var felicidonios

method felicidonios() = felicidonios

    method puedeCumplir(soniador)
    method cumplir(soniador){
        soniador.aumentarFelicidonios(felicidonios)
    } 
}

class Recibirse inherits Suenio{
    var carrera

    //method puedeCumplir(soniador) = soniador.carrerasQueQuiereEstudiar().contains(carrera) && !(soniador.carrerasQueEstudio().contains(carrera))
    //estos contains en la resolucion se hacen en la persona directamente, que tiene mas sentido
    // ademas podrias para cada validacion tirar un if con una excepcion para que el error sea mas preciso:
    
    override method puedeCumplir(soniador) {
        if(soniador.carrerasQueQuiereEstudiar().contains(carrera)){
            if(!(soniador.carrerasQueEstudio().contains(carrera))){
                return true
            }
            else{
                self.error("La persona ya estudio esa carrera")
            }
        }
        else{
            self.error("La persona no quiere estudiar la carrera")
        }
    }

    override method cumplir(soniador) {
        soniador.carreraEstudiada(carrera)
        super(soniador)
    }
}

class ConseguirUnTrabajo inherits Suenio {

    var sueldo

    override method puedeCumplir(soniador){
        if(sueldo >= soniador.plataQueQuiereGanar()){
            return true
        }
        else{
            self.error("El sueldo del trabajo es menor a la plata que la persona quiere ganar")
        }
    } 
}

class Adoptar inherits Suenio{
    var nombre

    override method puedeCumplir(soniador){
        if(soniador.noTieneHijos()){
            return true
        }
        else{
            self.error("No se puede adoptar si ya se tiene un hijo")
        }   
    }

    override method cumplir(soniador) {
        super(soniador)
        soniador.nuevoHijo()
    }
}

class TenerUnHijo inherits Suenio {
    override method puedeCumplir(soniador) = true

    override method cumplir(soniador) {
        super(soniador)
        soniador.nuevoHijo()
    }
}

class Viajar inherits Suenio {
    const lugar
    override method puedeCumplir(soniador) = true
    
    override method cumplir(soniador) {
        super(soniador)
        soniador.viajarA(lugar)
    }
}

class SuenioMultiple inherits Suenio {

    const suenios = [suenioDeViajarACataratas, suenioDeTener1Hijo, suenioDeNuevoTrabajo10000]

    override method felicidonios() = suenios.sum { suenio => suenio.felicidonios() } 
    override method puedeCumplir(soniador) = suenios.all{s => s.puedeCumplir(soniador)}
    // si alguna no puede, tirara error en su propio puedeCumplir

    override method cumplir(soniador){
        super(soniador)
        suenios.forEach{ s => s.cumplir(soniador) }
    }
}

class Lugar {
    var nombre
}
const cataratas= new Lugar(nombre=cataratas)
const suenioDeViajarACataratas = new Viajar(felicidonios=10, lugar=cataratas)
const suenioDeTener1Hijo = new TenerUnHijo(felicidonios=10)
const suenioDeNuevoTrabajo10000 = new ConseguirUnTrabajo(felicidonios=1, sueldo=10000)


/*
method validar(persona) {
		if (!persona.quiereEstudiar(carrera)) {
			error.throwExceptionWithMessage(persona.toString() + " no quiere estudiar " + carrera)
		}
		if (persona.completoCarrera(carrera)) {
			error.throwExceptionWithMessage(persona.toString() + " ya completó los estudios de " + carrera)
		}
	}
*/

