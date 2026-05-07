#include "TimeAndDate.h"

//default constructor
TimeAndDate::TimeAndDate() : minute(0), hour(0), day(1), month(1), year(2024) {}

//variable constructor
TimeAndDate::TimeAndDate(int minute, int hour, int day, int month, int year)
    : minute(minute), hour(hour), day(day), month(month), year(year) {}

//destructor
TimeAndDate::~TimeAndDate() {}

string TimeAndDate::toString() const{
    stringstream output;
    output << day << "/" << month << "/" << year;
    output << " " << hour << ":" << minute;

    return output.str();
}

ostream& operator<<(ostream& os, const TimeAndDate time_and_date){
    os << time_and_date.toString();
    return os;
}


