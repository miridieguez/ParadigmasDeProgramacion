object prueba {}

class Bot {
    var cargaElectrica
    var aceitePuro = true

    method cargaElectrica() = cargaElectrica 
    method aceitePuro() = aceitePuro 
    method aceiteSucio() = !aceitePuro
    
    method cambiarASucio() {
        aceitePuro = false
    }

    method recibirUnHechizo(hechizo) {
    }

    method disminuirCargaElectrica(disminucion) {
        cargaElectrica -= disminucion
    }

}

class Estudiante inherits Bot {

    var casa
    var hechizosAprendidos = []
    
    method casa() = casa
    method estaEnCasaPeligrosa() = casa.esPeligrosa() 
    method activo() = cargaElectrica > 0 
    method inactivo() = !self.activo() 
    method experimentado() = hechizosAprendidos.size() > 3 && self.cargaElectrica() > 50

    method ingresarALaEscuela() {
    const casaAsignada = sombrero.asignarCasa(self)
    casa = casaAsignada
    }

    method lanzarUnHechizo(hechizo,receptor) {
        if(self.puedeLanzarUnHechizo(hechizo)){
        hechizo.lanzar(receptor) //!
        }
    }

    method puedeLanzarUnHechizo(hechizo) = hechizosAprendidos.contains(hechizo) && self.activo() && hechizo.puedoLanzar(self)//!
}
class Casa {
    var integrantes = []

    method esPeligrosa() 
    method mayoriaDeIntegrantes() = integrantes.size() + 1
    method tieneMasIntegrantesDeAceiteSucio() = integrantes.filter{ e => e.aceiteSucio() }.size() > self.mayoriaDeIntegrantes() 
    method ingresarEstudiante(estudiante) {
    integrantes.add(estudiante)
    }

}
class Gryffindor inherits Casa{
    override method esPeligrosa() = false 
}
class Slytherin inherits Casa{
    override method esPeligrosa() = false 
}
class Ravenclaw inherits Casa{
    override method esPeligrosa() = self.tieneMasIntegrantesDeAceiteSucio()
}
class Huffelpuff inherits Casa{
    override method esPeligrosa() = self.tieneMasIntegrantesDeAceiteSucio()
}

object sombrero inherits Bot(cargaElectrica = 0) {
    const casas = [Huffelpuff,Ravenclaw,Slytherin,Gryffindor]
    
    method asignarCasa(estudiante) {
    const casa = casas.anyOne()
    casa.ingresarEstudiante(estudiante)
    return casa
    }
    
    override method cambiarASucio(){
    }

}

class Hechizo {
    method puedoLanzar(estudiante)
    method lanzar(estudiante)  
}
object inmobilus inherits Hechizo{
    override method puedoLanzar(estudiante) = true
    override method lanzar(receptor){
        receptor.disminuirCargaElectrica(50)
    }
}

object sectumSempra inherits Hechizo{
    override method puedoLanzar(estudiante) = estudiante.experimentado()
    override method lanzar(receptor){
        if(receptor.aceitePuro()){
            receptor.cambiarASucio()
        }
    }
}

object avadakedabra inherits Hechizo{
    override method puedoLanzar(estudiante) = estudiante.aceiteSucio() || estudiante.estaEnCasaPeligrosa()
    override method lanzar(receptor){
        if(receptor.aceitePuro()){
            receptor.cambiarASucio()
        }
    }
}

class HechizoComun inherits Hechizo {
    var disminucionCargaElectrica
    override method puedoLanzar(estudiante) = estudiante.cargaElectrica() > disminucionCargaElectrica
    override method lanzar(receptor){
        receptor.disminuirCargaElectrica(disminucionCargaElectrica)
    }
}

class Profesor inherits Bot {
    var casa
    override method disminuirCargaElectrica(disminucion){
    if(disminucion >= self.cargaElectrica()){
        self.disminuirCargaElectrica(self.cargaElectrica()/2)
    }
    }

    method ingresarALaEscuela() {
    const casaAsignada = sombrero.asignarCasa(self)
    casa = casaAsignada
    }
}