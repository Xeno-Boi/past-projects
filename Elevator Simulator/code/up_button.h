#ifndef UP_BUTTON_H
#define UP_BUTTON_H

#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

#include "floor_button.h"

using namespace std;

class UpButton : public FloorButton{
    public:
    UpButton();
    ~UpButton();

    void press() override;
};

#endif