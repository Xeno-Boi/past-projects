#include "open_button.h"

OpenButton::OpenButton(){}

OpenButton::~OpenButton(){}

void OpenButton::press(){
    emit(pressed(true));
}
