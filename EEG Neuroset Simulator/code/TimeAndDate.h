#ifndef TIMEANDDATE_H
#define TIMEANDDATE_H

#include <string>
#include <sstream>
#include <iostream>

using namespace std;

class TimeAndDate {
private:
    int minute;
    int hour;
    int day;
    int month;
    int year;

public:
    //constructors / destructor
    TimeAndDate();
    TimeAndDate(int minute, int hour, int day, int month, int year);
    ~TimeAndDate();

    //getters and setters
    inline int getMinute() const { return minute; };
    inline int getHour() const { return hour; };
    inline int getDay() const { return day; };
    inline int getMonth() const { return month; };
    inline int getYear() const { return year; };
    inline void setMinute(int minute) { this->minute = minute; };
    inline void setHour(int hour) { this->hour = hour; };
    inline void setDay(int day) { this->day = day; };
    inline void setMonth(int month) { this->month = month; };
    inline void setYear(int year) {this->year = year; };

    string toString() const;

    // overload <<
    friend ostream& operator<<(ostream& os, const TimeAndDate time_and_date);
};

#endif
