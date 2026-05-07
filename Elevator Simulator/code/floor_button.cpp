#include "floor_button.h"

FloorButton::FloorButton(){}

FloorButton::~FloorButton(){}

// slots
void FloorButton::press1Up(){
    emit(Signal_LightsUp(1, true));
    emit floorRequestUp(1);
}

void FloorButton::press2Up(){
    emit(Signal_LightsUp(2, true));
    emit floorRequestUp(2);
}

void FloorButton::press2Down(){
    emit(Signal_LightsUp(2, false));
    emit floorRequestDown(2);
}

void FloorButton::press3Up(){
    emit(Signal_LightsUp(3, true));
    emit floorRequestUp(3);
}

void FloorButton::press3Down(){
    emit(Signal_LightsUp(3, false));
    emit floorRequestDown(3);
}

void FloorButton::press4Up(){
    emit(Signal_LightsUp(4, true));
    emit floorRequestUp(4);
}

void FloorButton::press4Down(){
    emit(Signal_LightsUp(4, false));
    emit floorRequestDown(4);
}

void FloorButton::press5Up(){
    emit(Signal_LightsUp(5, true));
    emit floorRequestUp(5);
}

void FloorButton::press5Down(){
    emit(Signal_LightsUp(5, false));
    emit floorRequestDown(5);
}

void FloorButton::press6Up(){
    emit(Signal_LightsUp(6, true));
    emit floorRequestUp(6);
}

void FloorButton::press6Down(){
    emit(Signal_LightsUp(6, false));
    emit floorRequestDown(6);
}

void FloorButton::press7Down(){
    emit(Signal_LightsUp(7, false));
    emit floorRequestDown(7);
}

void FloorButton::lightsOff(int floor, bool up){
    emit(Signal_LightsOff(floor, up));
}
