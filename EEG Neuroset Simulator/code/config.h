#ifndef CONFIG_H
#define CONFIG_H

#include <string>
#include <sstream>
#include <iostream>

#include "TimeAndDate.h"

enum class SessionState{
    takingPreBaseline,
    takingSiteBaseline,
    treatingSite,
    takingPostBaseline,
    logging,
    paused,
    idle
};

struct SessionLog{
    // constructor
    SessionLog(TimeAndDate _time_and_date, float _pre_baseline, float _post_baseline){
        time_and_date = _time_and_date;
        pre_baseline = _pre_baseline;
        post_baseline = _post_baseline;
    }

    SessionLog(){
        time_and_date = TimeAndDate();
        pre_baseline = 0.0f;
        post_baseline = 0.0f;
    }

    string toString() const{
        stringstream output;
        output << "Time: " << time_and_date;
        output << " | pre baseline: " << pre_baseline;
        output << ", post baseline: " << post_baseline;
        return output.str();
    }

    string toTimeAndDate() const{
        return time_and_date.toString();
    }

    // overriding <<
    friend std::ostream& operator<<(std::ostream& os, const SessionLog& log){
        os << log.toString();
        return os;
    };

    // variables
    TimeAndDate time_and_date;
    float pre_baseline;
    float post_baseline;
};

// Menu Items
#define MENU_NEW_SESSION 0
#define MENU_SESSION_LOG 1
#define MENU_TIME_AND_DATE 2

// Sensor data
struct SensorData{
    // constructor
    SensorData(float amplitude_1, float amplitude_2, float amplitude_3, float frequency_1, float frequency_2, float frequency_3){
        this->amplitude_1 = amplitude_1;
        this->amplitude_2 = amplitude_2;
        this->amplitude_3 = amplitude_3;
        this->frequency_1 = frequency_1;
        this->frequency_2 = frequency_2;
        this->frequency_3 = frequency_3;
    }

    // variables
    float amplitude_1;
    float amplitude_2;
    float amplitude_3;

    float frequency_1;
    float frequency_2;
    float frequency_3;
};

#endif // CONFIG_H
