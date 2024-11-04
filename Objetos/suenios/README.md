## TP: Manejo de errores

Nos contrataron para armar un sistema desde el cual la gente con una tarjeta Biza pueda realizar operaciones con su cuenta.

Lo que queremos poder hacer con las cuenta es:
1. Consultar su saldo.
2. Depositar dinero.
3. Retirar dinero. No debería ser posible si se retira más del que hay en la cuenta.
4. Realizar una transacción de una cuenta a otra. Para que esto se pueda hacer la cuenta de la que sale la plata tiene que tener los fondos suficientes.
5. Debido a nuevas regulaciones, una cuenta no puede recibir más de 5 transacciones en el mismo mes* sin avisar al banco. Entonces, si una cuenta tratase de recibir una sexta transacción en el mismo mes y esa cuenta no dio aviso al banco, la operación debería fallar por completo. En caso de que si se haya dado aviso al banco, puede recibir cualquier número de transacciones.

```
* Para manejar fechas, busquen **Date** en la documentación de wollok: https://www.wollok.org/en/documentation/wollokdoc/.
`new Date()` les da la fecha de hoy.
```
