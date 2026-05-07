#include "audio.h"

Audio::Audio(){}

Audio::~Audio(){}

// slots
void Audio::playAudio(string message){
    emit(updateAudio(message));
}
