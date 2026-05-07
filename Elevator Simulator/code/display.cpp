#include "display.h"

Display::Display(){}

Display::~Display(){}

// slots
void Display::display(string message){
    emit(updateDisplay(message));
}
