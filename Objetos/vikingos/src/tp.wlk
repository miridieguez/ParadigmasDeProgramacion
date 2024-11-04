object prueba {}

/*Lo que queremos poder hacer con las cuenta es:

4. Realizar una transacción de una cuenta a otra. Para que esto se pueda hacer la cuenta de la que sale la plata tiene que 
tener los fondos suficientes.
5. Debido a nuevas regulaciones, una cuenta no puede recibir más de 5 transacciones en el mismo mes* sin avisar al banco. Entonces, 
si una cuenta tratase de recibir una sexta transacción en el mismo mes y esa cuenta no dio aviso al banco, 
la operación debería fallar por completo. 
En caso de que si se haya dado aviso al banco, puede recibir cualquier número de transacciones.*/

object cuenta {
    var saldo = 0
    var fechaDeTransaccionesRecibidas = new List()
    var fechaDeTransaccionesAvisadas = new List()
    // Se hacen dos listas para cubrir el caso de que el cliente avisa antes de hacer la transaccion.
    // En ese caso esa transaccion todavia no esta en la lista de transaccionesRecibidas, por lo que se agregara a la de transaccionesAvisadas
    
    method saldo() = saldo
    method fechaDeTransaccionesAvisadas() = fechaDeTransaccionesAvisadas
    method fechaDeTransaccionesRecibidas() = fechaDeTransaccionesRecibidas 

    method depositarDinero(cantidad) { 
    saldo += cantidad  //se suma la cantidad de dinero agregado al saldo actual
    }

    method retirarDinero(cantidad) { 
        if(!self.tieneFondosSuficientes(cantidad)){
            self.error("No hay suficiente dinero en la cuenta para retirar") 
        }
    saldo -= cantidad // se resta el dinero retirado del saldo actual
    }

    method realizarTransaccion(cantidad,otraCuenta) {
        self.retirarDinero(cantidad) //se resta el dinero de la cuenta que hace la transaccion
        otraCuenta.recibirTransaccion(cantidad) //la otra cuenta recibe el dinero
    }

    method recibirTransaccion(cantidad) { 
        if(!self.puedeRecibirTransaccion()){
            self.error("No es posible realizar mas de 5 transacciones al mes sin dar aviso al banco")
        }
        self.depositarDinero(cantidad)
        self.fechaDeTransaccionesRecibidas().add(date.fechaDeHoy()) //al recibir una transaccion se agrega la fecha de HOY a la lista y se deposita el dinero en la cuenta     
    }

    /* este es para probarlo por consola, agrega la fecha que vos queres a la lista
    method recibirTransaccion(cantidad,dia,mes,anio) { 
        if(!self.puedeRecibirTransaccion()){
            self.error("No es posible realizar mas de 5 transacciones al mes sin dar aviso al banco")
        }
    const fechaDeLaTransaccion = new Date(day = dia, month = mes, year = anio)
    self.depositarDinero(cantidad)
    self.fechaDeTransaccionesRecibidas().add(fechaDeLaTransaccion)      
    }*/

    method avisarAlBancoSobreUnaTransaccion(dia,mes,anio) {
        const fechaDeLaTransaccion = new Date(day = dia, month = mes, year = anio)
        self.fechaDeTransaccionesAvisadas().add(fechaDeLaTransaccion)    
        // Si en vez de esto hacia un remove en transaccionesRecibidas, podria pasar que el cliente haya avisado antes de hacerla entonces no va encontrar nada en la lista de transacciones recibidas        
    }

    method tieneFondosSuficientes(cantidad) = cantidad<= saldo 

    method puedeRecibirTransaccion() = self.cantidadDeTransaccionesNoAvisadasEnElMes() < 5

    method cantidadDeTransaccionesAvisadasEnElMes() =  self.transaccionesEnElMes(self.fechaDeTransaccionesAvisadas()).size() //se obtiene la cantidad de avisos en este mes
    method cantidadDeTransaccionesNoAvisadasEnElMes() = (self.transaccionesEnElMes(self.fechaDeTransaccionesRecibidas()).size() - self.cantidadDeTransaccionesAvisadasEnElMes()).max(0) //se obtiene la cantidad de transacciones que se hicieron pero no fueron avisadas
    //aclaracion: suponemos que todas las transacciones avisadas fueron realizadas

    method transaccionesEnElMes(transacciones) {
        return transacciones.filter {fecha => date.esFechaDeEsteMes(fecha)} //filtrado de fechas, quedan las de este mes, que es lo que nos sirve para comprobar que sean menos de 5 no avisadas
    }
}

object date {
    const hoy = new Date()
    
    method fechaDeHoy() = hoy

    method esFechaDeEsteMes(fecha) =  fecha.month() == hoy.month() && fecha.year() == hoy.year()
}

