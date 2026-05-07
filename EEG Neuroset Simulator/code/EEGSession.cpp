#include "EEGSession.h"
#include <iostream>

EEGSession::EEGSession() {
    for (int i = 0; i < 21; ++i) {
        sites[i] = EEGSensor();
    }
}

EEGSession::~EEGSession() {}

void EEGSession::connectionLost() {
    // Placeholder implementation, replace with actual functionality
    std::cout << "Connection lost." << std::endl;
}

// Method to pause the session
void EEGSession::sessionPaused() {
    // Placeholder implementation, replace with actual functionality
    std::cout << "Session paused." << std::endl;
}

// Method to resume the session
void EEGSession::sessionResume() {
    // Placeholder implementation, replace with actual functionality
    std::cout << "Session resumed." << std::endl;
}

// Method to start the session
void EEGSession::sessionStart() {
    // Placeholder implementation, replace with actual functionality
    std::cout << "Session started." << std::endl;
}
