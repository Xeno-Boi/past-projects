#include "weight_sensor.h"

WeightSensor::WeightSensor(){}

WeightSensor::~WeightSensor(){}

// slots
void WeightSensor::overload(){
    overweight = true;
    emit(Signal_Overload());
}

void WeightSensor::normalLoad(){
    overweight = false;
    emit(Signal_NormalLoad());
}
