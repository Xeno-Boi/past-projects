#include "down_button.h"

DownButton::DownButton() : FloorButton(){
    type = "down";
}

DownButton::~DownButton(){}

void DownButton::press(){
    pressed = true;
}
