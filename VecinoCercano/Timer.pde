// https://forum.processing.org/one/topic/timer-in-processing.html

class Timer {
  int startTime = 0, stopTime = 0;
  boolean running = false;  
  
  void iniciar() {
    this.startTime = millis();
    this.running = true;
  }
  
  void parar() {
    this.stopTime = millis();
    this.running = false;
  }
  
  int tiempoTranscurrido() {
    return this.running? millis()-this.startTime: this.stopTime-this.startTime;
  }
  
  float segundos() {
    return this.tiempoTranscurrido()/1000.0;
  }
}
