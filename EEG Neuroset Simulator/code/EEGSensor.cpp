#include "EEGSensor.h"
#include <iostream>

//constructor/destructor
EEGSensor::EEGSensor() {
    // connect
    connect(&treatment_timer, SIGNAL(timeout()), this, SLOT(treatmentTimerTimeout()));
}

EEGSensor::~EEGSensor() {}

//takes the baseline of a given sensor site
float EEGSensor::takeBaseline() {
    visit();
    float final_baseline = (frequency_1 * amplitude_1 * amplitude_1 + frequency_2 * amplitude_2 * amplitude_2 + frequency_3 * amplitude_3 * amplitude_3) / (amplitude_1 * amplitude_1 + amplitude_2 * amplitude_2 + amplitude_3 * amplitude_3);
    return final_baseline;
}

void EEGSensor::startTreatment(float baseline) {
    if (!treating){
        treating = true;
        treatment_baseline = baseline + 5;
        treatmentTimerTimeout();
    }
}

void EEGSensor::pauseTreatment(){
    if (treating){
        treatment_timer.pause();
    }
}

void EEGSensor::resumeTreatment(){
    if (treating){
        treatment_timer.resume();
    }
}

void EEGSensor::stopTreatment(){
    treating = false;
    treatment_timer.stop();
}

void EEGSensor::reset(){
    siteVisited = false;
    treating = false;
    treatment_baseline = 0;
    treatment_timer.stop();
}

void EEGSensor::loadData(SensorData data){
    amplitude_1 = data.amplitude_1;
    amplitude_2 = data.amplitude_2;
    amplitude_3 = data.amplitude_3;
    frequency_1 = data.frequency_1;
    frequency_2 = data.frequency_2;
    frequency_3 = data.frequency_3;
}

void EEGSensor::applyTreatment(){
    frequency_1 = treatment_baseline;
    frequency_2 = treatment_baseline;
    frequency_3 = treatment_baseline;
}

// slots

void EEGSensor::treatmentTimerTimeout(){
    applyTreatment();
    treatment_timer.start(treatment_time);
}
