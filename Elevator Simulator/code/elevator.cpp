#include "elevator.h"

Elevator::Elevator(int id){
    this->id = id;

    setUp();

    // signal connect
    // floor button
    connect(this->elevator_floor_button, SIGNAL(press(int)), this, SLOT(selfFloorRequest(int)));
    // car
    connect(this, SIGNAL(Signal_MoveUp()), this->car, SLOT(moveUp()));
    connect(this, SIGNAL(Signal_MoveDown()), this->car, SLOT(moveDown()));
    connect(this, SIGNAL(Signal_MoveStop()), this->car, SLOT(moveStop()));
    // floor sensor
    connect(this->floor_sensor, SIGNAL(newFloor()), this, SLOT(newFloor()));
    // open button
    connect(this->open_button, SIGNAL(pressed(bool)), this, SLOT(openDoor(bool)));
    // close button
    connect(this->close_button, SIGNAL(pressed()), this, SLOT(closeDoor()));
    // door
    connect(this, SIGNAL(Signal_OpenDoor()), this->door, SLOT(open()));
    connect(this, SIGNAL(Signal_OpenDoor(int)), this->door, SLOT(open(int)));
    connect(this, SIGNAL(Signal_CloseDoor()), this->door, SLOT(close()));
    connect(this->door, SIGNAL(closeDoor()), this, SLOT(closeDoor()));
    connect(this->door, SIGNAL(closed()), this, SLOT(door_closed()));
    // bell
    connect(this, SIGNAL(Signal_RingBell()), this->bell, SLOT(ring()));
    // audio
    connect(this, SIGNAL(Signal_Audio(string)), this->audio_object, SLOT(playAudio(string)));
    // display
    connect(this, SIGNAL(Signal_Display(string)), this->display_object, SLOT(display(string)));
    // help button
    connect(this->help_button, SIGNAL(help()), this, SLOT(help()));
    // door sensor
    connect(this->door_sensor, SIGNAL(doorObstructs()), this, SLOT(doorObstructs()));
    // weight sensor
    connect(this->weight_sensor, SIGNAL(Signal_Overload()), this, SLOT(overload()));
    connect(this->weight_sensor, SIGNAL(Signal_NormalLoad()), this, SLOT(normalLoad()));
}

Elevator::~Elevator(){
    delete audio_object;
    delete bell;
    delete car;
    delete close_button;
    delete display_object;
    delete door;
    delete elevator_floor_button;
    delete floor_sensor;
    delete help_button;
    delete open_button;
    delete weight_sensor;
}

// creates objects for the elevator
void Elevator::setUp(){
    audio_object = new Audio();
    bell = new Bell();
    car = new Car();
    close_button = new CloseButton();
    display_object = new Display();
    door = new Door();
    door_sensor = new DoorSensor();
    elevator_floor_button = new ElevatorFloorButton();
    floor_sensor = new FloorSensor();
    help_button = new HelpButton();
    open_button = new OpenButton();
    weight_sensor = new WeightSensor();
}

// called when elevator arrives at destination floor
void Elevator::arrive(){
    // stop moving
    emit(Signal_MoveStop());
    moving = STOP;
    // update destination
    destination_floors.erase(destination);
    if (destination_floors.empty()){
        // all destinations visited
        direction = STOP;
        destination = -1;
        emit(Signal_Available(id));
    }
    if (direction == GOING_UP){
        destination = findMin(destination_floors);
    } else if (direction == GOING_DOWN){
        destination = findMax(destination_floors);
    }
    // ring bell
    cout<<"elevator "<<id + 1<<": ";
    emit(Signal_RingBell());
    if (in_emergency){
        openDoor(false);    // leave door open
        display("Please leave elevator");
        playAudio("Please leave elevator");
    } else {
        openDoor(true);     // door automatically closes
    }
    emit(Signal_Arrive(current_floor, direction));
}

// called when an up floor button is pressed
bool Elevator::floorRequestUp(int floor){
    bool output = false;
    // update destination
    if (!in_emergency){
        if (destination_floors.empty()){
            // no destination
            if (floor == current_floor){
                // stopped at requested floor
                emit(openDoor(true));
                emit(Signal_Arrive(current_floor, direction));
                output = true;
            } else {
                destination_floors.insert(floor);
                destination = findMin(destination_floors);
                // find direction
                if (destination > current_floor){
                    direction = GOING_UP;
                } else {
                    direction = GOING_DOWN;
                }
                output = true;
            }
        } else if (direction == GOING_UP){
            // request direction same as moving direction
            if (floor > current_floor){
                // requested floor is above current floor
                destination_floors.insert(floor);
                destination = findMin(destination_floors);
                output = true;
            }
        }
    }

    // start moving
    start_moving();
    return output;
}

// called when a down floor button is pressed
bool Elevator::floorRequestDown(int floor){
    bool output = false;
    // update destination
    if (!in_emergency){
        if (destination_floors.empty()){
            // no destination
            if (floor == current_floor){
                // stopped at requested floor
                emit(openDoor(true));
                emit(Signal_Arrive(current_floor, direction));
                output = true;
            } else {
                destination_floors.insert(floor);
                destination = findMin(destination_floors);
                // find direction
                if (destination > current_floor){
                    direction = GOING_UP;
                } else {
                    direction = GOING_DOWN;
                }
                output = true;
            }
        } else if (direction == GOING_DOWN){
            // request direction same as moving direction
            if (floor < current_floor){
                // requested floor is below current floor
                destination_floors.insert(floor);
                destination = findMax(destination_floors);
                output = true;
            }
        }
    }

    // start moving
    start_moving();
    return output;
}

void Elevator::display(string message){
    emit(Signal_Display(message));
}

void Elevator::playAudio(string message){
    emit(Signal_Audio(message));
}

void Elevator::callEmergencyService(){
    cout<<"elevator "<<id + 1<<": ";
    cout<<"called emergency service"<<endl;
}

void Elevator::callBuildingSafety(){
    cout<<"elevator "<<id + 1<<": ";
    cout<<"calling building safety"<<endl;
    // time for building safety to reply
    QTimer::singleShot(building_safety_timeout_seconds * 1000, this, SLOT(buildingSafetyTimeout()));
}

void Elevator::start_moving(){
    // is stopped
    // has valid destination
    // door is not opened
    if ( moving == STOP && destination != -1 && door->isClosed()){
        if ( direction == GOING_UP ){
            moving = GOING_UP;
            emit(Signal_MoveUp());
        } else {
            moving = GOING_DOWN;
            emit(Signal_MoveDown());
        }
    }
}


// slots

// called when elevator floor button is pressed
void Elevator::selfFloorRequest(int floor){
    // update destination
    // ignores request of floors on the opposite of the moving direction
    if ( floor != current_floor && !in_emergency ){
        if ( destination_floors.empty() ){
            // no destination
            destination_floors.insert(floor);
            destination = findMin(destination_floors);
            // find direction
            if (destination > current_floor){
                direction = GOING_UP;
            } else {
                direction = GOING_DOWN;
            }
        } else if ( direction == GOING_UP && floor > current_floor ){
            // requested floor is in moving direction
            destination_floors.insert(floor);
            destination = findMin(destination_floors);
        } else if ( direction == GOING_DOWN && floor < current_floor ){
            // requested floor is in moving direction
            destination_floors.insert(floor);
            destination = findMax(destination_floors);
        }
    }

    // start moving
    start_moving();
}

// called when floor sensor detects a floor
void Elevator::newFloor(){
    if (moving == GOING_UP){
        current_floor += 1;
    } else if (moving == GOING_DOWN) {
        current_floor -= 1;
    }
    if (current_floor == destination){
        arrive();
    }
    emit(updateFloorDisplay(current_floor));
}

// called to open door
void Elevator::openDoor(bool auto_close){
    if (moving == STOP){
        if (auto_close){
            emit(Signal_OpenDoor(10));
        } else {
            emit(Signal_OpenDoor());
        }
    }
}

// called to close door
void Elevator::closeDoor(){
    // elevator must be stopped, not overloaded and not in emergency
    if (moving == STOP && !weight_sensor->isOverloaded() && !in_emergency){
        emit(Signal_CloseDoor());
        if (door_sensor->isObstructed()){
            emit(doorObstructs());
        }
        // reset display and audio
        display("");
        playAudio("");
    }
}

// called when door is completed closed
void Elevator::door_closed(){
    cout<<"elevator "<<id + 1<<": ";
    emit(Signal_RingBell());
    start_moving();
}

// called when help button is pressed
void Elevator::help(){
    building_safety_replied = false;
    callBuildingSafety();
}

// called when building safety replied
void Elevator::buildingSafetyReplied(){
    building_safety_replied = true;
}

// called after the timer for building safety reply is over
void Elevator::buildingSafetyTimeout(){
    if (building_safety_replied){
        cout<<"elevator "<<id + 1<<": ";
        cout<<"building safety replied"<<endl;
        building_safety_replied = false;
    } else {
        callEmergencyService();
    }
}

// called when door sensor senses obstacles
void Elevator::doorObstructs(){
    if (door->isClosing()){
        emit(Signal_OpenDoor(5));
        QTimer::singleShot(5000, this, SLOT(doorObstructTimeout()));
    }
}

// called after the door sensor has been obstructed for 5 seconds
void Elevator::doorObstructTimeout(){
    if (door_sensor->isObstructed()){
        display("Please do not obstruct door.");
        playAudio("Please do not obstruct door.");
    }
}


// called when weight sensor senses overweight
void Elevator::overload(){
    if (moving == STOP && !in_emergency){
        emit(Signal_OpenDoor());
        display("Warning: Overload, please remove some load");
        playAudio("Warning: Overload, please remove some load");
    }
}

// called when weight sensor senses normal weight
void Elevator::normalLoad(){
    if (moving == STOP){
        emit(Signal_OpenDoor(2));
    }
}

// called during emergency
void Elevator::emergency(int emergency){
    switch(emergency){
    case EMERGENCY:
        display("Warning: Emergency");
        playAudio("Warning: Emergency");
        break;
    case FIRE:
        display("Warning: Fire");
        playAudio("Warning: Fire");
        break;
    case POWER_OUT:
        display("Warning: Power Outage");
        playAudio("Warning: Power Outage");
        break;
    }
    in_emergency = true;
    if (moving == STOP){
        openDoor(false);
        display("Please leave elevator");
        playAudio("Please leave elevator");
    } else {
        // move to safe floor (closest floor in moving direction)
        destination_floors.clear();
        if (moving == GOING_UP){
            destination = current_floor + 1;
        } else {
            destination = current_floor - 1;
        }
    }
}


// helper

// finds minimum value in a set
int Elevator::findMin(set<int> s){
    if (!s.empty()){
        return *s.begin();
    } else {
        return -1;
    }
}

// finds maximum value in a set
int Elevator::findMax(set<int> s){
    if (!s.empty()){
        return *prev(s.end());
    } else {
        return -1;
    }
}

// for testing
void Elevator::debug(){
    cout << "{ ";
    for (auto& str : destination_floors){
        cout << str << " ";
    }
    cout << "}" << endl;
}
