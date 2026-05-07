#include "floor_sensor.h"

FloorSensor::FloorSensor(){
}

FloorSensor::~FloorSensor(){};

// slots
void FloorSensor::detectFloor(){
    emit(newFloor());
}
