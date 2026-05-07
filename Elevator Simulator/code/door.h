#ifndef DOOR_H
#define DOOR_H

#include <QObject>
#include <QTimer>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

#define OPENED 1
#define CLOSED 2
#define OPENING 3
#define CLOSING 4

using namespace std;

class Door : public QObject{
    Q_OBJECT

    public:
    Door();
    ~Door();
    
    inline bool isClosed(){ return (status == CLOSED); };
    inline bool isClosing(){ return (status == CLOSING); };

    private:    
    int status = CLOSED;    // keeps track of if the door is opened

    int door_movement_time = 2;      // time needed to open and close door

    int door_open_time = -1;    // keeps track of time the door needed to stay open for, dynamically assigned

    // timer
    QTimer timer;

signals:
    void updateDoorDisplay(string);
    void closeDoor();
    void closed();

public slots:
    void open();    // door does not closes automatically
    void open(int seconds);     // door closes after timer ends
    void close();
    void doorOpened();
    void doorClosed();
    void doorTimerTimeout();
};

#endif
