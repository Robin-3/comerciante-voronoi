// https://forum.processing.org/one/topic/timer-in-processing.html

class Timer {
  int startTime = 0, stopTime = 0;
  boolean running = false;  
  
  void start() {
    this.startTime = millis();
    this.running = true;
  }
  
  void stop() {
    this.stopTime = millis();
    this.running = false;
  }
  
  int elapsedTime() {
    return this.running? millis()-this.startTime: this.stopTime-this.startTime;
  }
  
  float seconds() {
    return this.elapsedTime()/1000.0;
  }
}
