#include "car.h"

Car::Car(){}

Car::~Car(){}

void Car::moveUp(){
    emit(updateDirectionDisplay("Going Up"));
}

void Car::moveDown(){
    emit(updateDirectionDisplay("Going Down"));
}

void Car::moveStop(){
    emit(updateDirectionDisplay("Stopped"));
}
