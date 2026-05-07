#ifndef EEGSESSION_H
#define EEGSESSION_H

#include "EEGSensor.h"

class EEGSession {

public:
    EEGSession();
    ~EEGSession();

    void connectionLost();
    void sessionPaused();
    void sessionResume();
    void sessionStart();

private:
    EEGSensor sites[21];

};

#endif // EEGSESSION_H
