class Nave {
  var direccion //Numero de entre -10 y 10
  var property velocidad //Numero de entre 0 y 100000
  var property combustible //Numero

  method acelerar(cuanto) {
    velocidad = (velocidad + cuanto).min(100000)
  }

  method desacelerar(cuanto) {
    velocidad = (velocidad - cuanto).max(0)
  }

  method irHaciaElSol() {
    direccion = 10
  }
  method escaparDelSol() {
    direccion = -10
  }
  method ponerseParaleloAlSol() {
    direccion = 0
  }
  
  method acercarseUnPocoAlSol() {
    direccion = (direccion +1).min(10)
  }
  method alejarseUnPocoDelSol() {
    direccion = (direccion -1).max(-10)
  }

  method agregarCombustible(cantidad) {
    combustible += cantidad
  }
  method descargarCombustible(cantidad) {
    combustible -= cantidad
  }

  method prepararViaje() {
    self.agregarCombustible(30000)
    self.acelerar(5000)
  }

  method estaTranquila() =
    self.combustible() >= 4000 && self.velocidad() <= 12000

  method recibirAmenaza() {
    self.escapar()
    self.avisar()
  }
  method escapar() {}
  method avisar() {}

  method estaDeRelajo() = 
    self.estaTranquila()
}

class NavesBaliza inherits Nave {
  var property colorDeBaliza //String
  var property cambioDeColor = false

  method cambiarColorDeBaliza(nuevoColor) {
    colorDeBaliza = nuevoColor
    cambioDeColor = true
  }

  override method prepararViaje(){
    super()
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }

  override method estaTranquila() = 
    super() && self.colorDeBaliza() != "rojo"
  
  override method escapar(){
    self.irHaciaElSol()
  }
  override method avisar() {
    self.cambiarColorDeBaliza("rojo")
  }

  override method estaDeRelajo() = 
    super() && !self.cambioDeColor()
}

class NavesDePasajeros inherits Nave {
  var cantidadDePasajeros //Numero
  var registroDeComida = 0 
  var registroDeBebida = 0
  var property racionesServidas = 0

  method agregarComida(cantidad) {
    registroDeComida += cantidad
  }
  method descargarComida(cantidad) {
    registroDeComida -= cantidad
    racionesServidas += cantidad
  }

  method agregarBebida(cantidad) {
    registroDeBebida += cantidad
  }
  method descargarBebida(cantidad) {
    registroDeBebida -= cantidad
  }

  method modificarCantidadDePasajeros(cantidad) {
    cantidadDePasajeros = cantidad
  }

  override method prepararViaje(){
    super()
    self.agregarComida(4*cantidadDePasajeros)
    self.agregarBebida(6*cantidadDePasajeros)
    self.acercarseUnPocoAlSol()
  }

  override method escapar(){
    self.acelerar(velocidad*2)
  }
  override method avisar() {
    self.descargarComida(1*cantidadDePasajeros)
    self.descargarBebida(2*cantidadDePasajeros)
  }

  override method estaDeRelajo() = 
    super() && self.racionesServidas() < 50
}

class NaveDeCombate inherits Nave {
  var property estaInvisible = false
  var property misilesDesplegados = false
  const property mensajesEmitidos = []

  method ponerseVisible() {
    estaInvisible = false
  }
  method ponerseInvisible() {
    estaInvisible = true
  }

  method desplegarMisiles() {
    misilesDesplegados = true
  }
  method replegarMisiles() {
    misilesDesplegados = false
  }

  method emitirMensaje(mensaje) {
    mensajesEmitidos.add(mensaje)
  }
  method primerMensajeEmitido() = mensajesEmitidos.first()
  method ultimoMensajeEmitido() = mensajesEmitidos.last()
  method esEscueta() = 
    !mensajesEmitidos.any({m => m.length() > 30})
  method emitioMensaje(mensaje) =
    mensajesEmitidos.contains(mensaje)

  override method prepararViaje(){
    super()
    self.ponerseVisible()
    self.replegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en misión")
  }

  override method estaTranquila() = 
    super() && !self.misilesDesplegados()
  
  override method escapar(){
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar() {
    self.emitirMensaje("Amenaza recibida")
  }
}

class NaveHospital inherits NavesDePasajeros {
  var property quirofanosPreparados = false

  method prepararQuirofano() {
    quirofanosPreparados = true
  }

  override method estaTranquila() = 
    super() && !self.quirofanosPreparados()

  override method recibirAmenaza() {
    super()
    self.prepararQuirofano()
  }
}

class NaveDeCombateSigilosa inherits NaveDeCombate {
  override method estaTranquila() = 
    super() && !self.estaInvisible()

  override method escapar() {
    super()
    self.ponerseInvisible()
    self.desplegarMisiles()
  }
}