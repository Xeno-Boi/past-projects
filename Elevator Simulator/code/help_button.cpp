#include "help_button.h"

HelpButton::HelpButton(){}

HelpButton::~HelpButton(){}


// slots
void HelpButton::press(){
    emit(help());
}
