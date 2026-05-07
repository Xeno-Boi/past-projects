#ifndef AUDIO_H
#define AUDIO_H

#include <QObject>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <iostream>

using namespace std;

class Audio : public QObject{
    Q_OBJECT

public:
    Audio();
    ~Audio();

signals:
    void updateAudio(string);

public slots:
    void playAudio(string);
};

#endif
