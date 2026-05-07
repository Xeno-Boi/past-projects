#include "ecs.h"

ECS::ECS(){
    for (int i = 0; i < n; i++){
        elevators.push_back(new Elevator(i));
    }
    floor_button = new FloorButton();

    // connect
    // elevator
    for (Elevator* elevator : elevators){
        connect(elevator, SIGNAL(Signal_Available(int)), this, SLOT(elevatorAvailable(int)));
        connect(elevator, SIGNAL(Signal_Arrive(int, int)), this, SLOT(elevatorArrives(int, int)));
    }

    // floor button
    connect(this->floor_button, SIGNAL(floorRequestDown(int)), this, SLOT(floorRequestDown(int)));
    connect(this->floor_button, SIGNAL(floorRequestUp(int)), this, SLOT(floorRequestUp(int)));
    connect(this, SIGNAL(lightsOffFloorButton(int, bool)), this->floor_button, SLOT(lightsOff(int, bool)));
}

ECS::~ECS(){
    for (Elevator* elevator : elevators){
        delete elevator;
    }
    elevators.clear();
    delete floor_button;
}

// helpers
void ECS::test(){
    for (int i = 0; i < n; i++){
        elevators[i]->debug();
    }
}


// slots
void ECS::floorRequestUp(int floor){
    bool assigned = false;
    // request to every elevator
    for (int i = 0; i < n && !assigned; i++){
        assigned = elevators[i]->floorRequestUp(floor);
    }
    // no elevator assigned
    if (!assigned){
        requested_floors_up.insert(floor);
    }
}

void ECS::floorRequestDown(int floor){
    bool assigned = false;
    // request to every elevator
    for (int i = 0; i < n && !assigned; i++){
        assigned = elevators[i]->floorRequestDown(floor);
    }
    // no elevator assigned
    if (!assigned){
        requested_floors_down.insert(floor);
    }
}

// called when en elevator has visited all its destination
void ECS::elevatorAvailable(int id){
    vector<int> assigned_floors;    // to store floors assigned from buffer set
    assigned_floors.clear();
    if (!requested_floors_up.empty()){
        // assign up request
        for (auto& floor : requested_floors_up){
            bool assigned = false;
            assigned = elevators[id]->floorRequestUp(floor);
            if (assigned){
                assigned_floors.push_back(floor);
            }
        }
    } else if (!requested_floors_down.empty()){
        // assign down request
        for (auto& floor : requested_floors_down){
            bool assigned = false;
            assigned = elevators[id]->floorRequestDown(floor);
            if (assigned){
                assigned_floors.push_back(floor);
            }
        }
    }
    // remove assigned floors from buffer set
    for (auto& i : assigned_floors){
        requested_floors_up.erase(i);
        requested_floors_down.erase(i);
    }
    assigned_floors.clear();
}

// called when an elevator arrives at a certain floor to turn off floor button lights
void ECS::elevatorArrives(int floor, int direction){
    switch(direction){
    case GOING_UP:
        emit(lightsOffFloorButton(floor, true));
        break;
    case GOING_DOWN:
        emit(lightsOffFloorButton(floor, false));
        break;
    case STOP:
        emit(lightsOffFloorButton(floor, true));
        emit(lightsOffFloorButton(floor, false));
    }
    // edge case ( 1st, 7th floor )
    switch(floor){
    case 1:
        emit(lightsOffFloorButton(floor, true));
    case 7:
        emit(lightsOffFloorButton(floor, false));
    }

}

void ECS::emergency(){
    for (Elevator* elevator : elevators){
        elevator->emergency(EMERGENCY);
    }
    // clears buffer set
    requested_floors_down.clear();
    requested_floors_up.clear();
}

void ECS::fire(){
    for (Elevator* elevator : elevators){
        elevator->emergency(FIRE);
    }
    // clears buffer set
    requested_floors_down.clear();
    requested_floors_up.clear();
}

void ECS::power_out(){
    for (Elevator* elevator : elevators){
        elevator->emergency(POWER_OUT);
    }
    // clears buffer set
    requested_floors_down.clear();
    requested_floors_up.clear();
}

// for debug
void ECS::debug(){
    cout << "{ ";
    for (auto& str : requested_floors_up){
        cout << str << " ";
    }
    cout << "}" << endl;
    cout << "{ ";
    for (auto& str : requested_floors_down){
        cout << str << " ";
    }
    cout << "}" << endl;
}
