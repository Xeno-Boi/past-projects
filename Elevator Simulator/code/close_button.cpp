#include "close_button.h"

CloseButton::CloseButton(){}

CloseButton::~CloseButton(){}

void CloseButton::press(){
    emit(pressed());
}
