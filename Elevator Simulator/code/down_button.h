#ifndef DOWN_BUTTON_H
#define DOWN_BUTTON_H

#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

#include "floor_button.h"

using namespace std;

class DownButton : public FloorButton{
    public:
    DownButton();
    ~DownButton();

    void press() override;
};

#endif
