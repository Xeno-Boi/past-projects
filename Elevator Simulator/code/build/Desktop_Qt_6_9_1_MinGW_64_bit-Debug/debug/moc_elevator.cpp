/****************************************************************************
** Meta object code from reading C++ file 'elevator.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../elevator.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'elevator.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.9.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN8ElevatorE_t {};
} // unnamed namespace

template <> constexpr inline auto Elevator::qt_create_metaobjectdata<qt_meta_tag_ZN8ElevatorE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "Elevator",
        "Signal_MoveUp",
        "",
        "Signal_MoveDown",
        "Signal_MoveStop",
        "updateFloorDisplay",
        "Signal_OpenDoor",
        "seconds",
        "Signal_CloseDoor",
        "Signal_RingBell",
        "Signal_Display",
        "string",
        "Signal_Audio",
        "Signal_Available",
        "id",
        "Signal_Arrive",
        "floor",
        "direction",
        "selfFloorRequest",
        "newFloor",
        "openDoor",
        "auto_close",
        "closeDoor",
        "door_closed",
        "help",
        "buildingSafetyReplied",
        "buildingSafetyTimeout",
        "doorObstructs",
        "doorObstructTimeout",
        "overload",
        "normalLoad",
        "emergency",
        "debug"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'Signal_MoveUp'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'Signal_MoveDown'
        QtMocHelpers::SignalData<void()>(3, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'Signal_MoveStop'
        QtMocHelpers::SignalData<void()>(4, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'updateFloorDisplay'
        QtMocHelpers::SignalData<void(int)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 2 },
        }}),
        // Signal 'Signal_OpenDoor'
        QtMocHelpers::SignalData<void()>(6, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'Signal_OpenDoor'
        QtMocHelpers::SignalData<void(int)>(6, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 7 },
        }}),
        // Signal 'Signal_CloseDoor'
        QtMocHelpers::SignalData<void()>(8, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'Signal_RingBell'
        QtMocHelpers::SignalData<void()>(9, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'Signal_Display'
        QtMocHelpers::SignalData<void(string)>(10, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 11, 2 },
        }}),
        // Signal 'Signal_Audio'
        QtMocHelpers::SignalData<void(string)>(12, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 11, 2 },
        }}),
        // Signal 'Signal_Available'
        QtMocHelpers::SignalData<void(int)>(13, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 14 },
        }}),
        // Signal 'Signal_Arrive'
        QtMocHelpers::SignalData<void(int, int)>(15, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 16 }, { QMetaType::Int, 17 },
        }}),
        // Slot 'selfFloorRequest'
        QtMocHelpers::SlotData<void(int)>(18, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 16 },
        }}),
        // Slot 'newFloor'
        QtMocHelpers::SlotData<void()>(19, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'openDoor'
        QtMocHelpers::SlotData<void(bool)>(20, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 21 },
        }}),
        // Slot 'closeDoor'
        QtMocHelpers::SlotData<void()>(22, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'door_closed'
        QtMocHelpers::SlotData<void()>(23, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'help'
        QtMocHelpers::SlotData<void()>(24, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'buildingSafetyReplied'
        QtMocHelpers::SlotData<void()>(25, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'buildingSafetyTimeout'
        QtMocHelpers::SlotData<void()>(26, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'doorObstructs'
        QtMocHelpers::SlotData<void()>(27, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'doorObstructTimeout'
        QtMocHelpers::SlotData<void()>(28, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'overload'
        QtMocHelpers::SlotData<void()>(29, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'normalLoad'
        QtMocHelpers::SlotData<void()>(30, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'emergency'
        QtMocHelpers::SlotData<void(int)>(31, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 2 },
        }}),
        // Slot 'debug'
        QtMocHelpers::SlotData<void()>(32, 2, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<Elevator, qt_meta_tag_ZN8ElevatorE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject Elevator::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN8ElevatorE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN8ElevatorE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN8ElevatorE_t>.metaTypes,
    nullptr
} };

void Elevator::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<Elevator *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->Signal_MoveUp(); break;
        case 1: _t->Signal_MoveDown(); break;
        case 2: _t->Signal_MoveStop(); break;
        case 3: _t->updateFloorDisplay((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 4: _t->Signal_OpenDoor(); break;
        case 5: _t->Signal_OpenDoor((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 6: _t->Signal_CloseDoor(); break;
        case 7: _t->Signal_RingBell(); break;
        case 8: _t->Signal_Display((*reinterpret_cast< std::add_pointer_t<string>>(_a[1]))); break;
        case 9: _t->Signal_Audio((*reinterpret_cast< std::add_pointer_t<string>>(_a[1]))); break;
        case 10: _t->Signal_Available((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 11: _t->Signal_Arrive((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        case 12: _t->selfFloorRequest((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 13: _t->newFloor(); break;
        case 14: _t->openDoor((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 15: _t->closeDoor(); break;
        case 16: _t->door_closed(); break;
        case 17: _t->help(); break;
        case 18: _t->buildingSafetyReplied(); break;
        case 19: _t->buildingSafetyTimeout(); break;
        case 20: _t->doorObstructs(); break;
        case 21: _t->doorObstructTimeout(); break;
        case 22: _t->overload(); break;
        case 23: _t->normalLoad(); break;
        case 24: _t->emergency((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 25: _t->debug(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (Elevator::*)()>(_a, &Elevator::Signal_MoveUp, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (Elevator::*)()>(_a, &Elevator::Signal_MoveDown, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (Elevator::*)()>(_a, &Elevator::Signal_MoveStop, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (Elevator::*)(int )>(_a, &Elevator::updateFloorDisplay, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (Elevator::*)()>(_a, &Elevator::Signal_OpenDoor, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (Elevator::*)(int )>(_a, &Elevator::Signal_OpenDoor, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (Elevator::*)()>(_a, &Elevator::Signal_CloseDoor, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (Elevator::*)()>(_a, &Elevator::Signal_RingBell, 7))
            return;
        if (QtMocHelpers::indexOfMethod<void (Elevator::*)(string )>(_a, &Elevator::Signal_Display, 8))
            return;
        if (QtMocHelpers::indexOfMethod<void (Elevator::*)(string )>(_a, &Elevator::Signal_Audio, 9))
            return;
        if (QtMocHelpers::indexOfMethod<void (Elevator::*)(int )>(_a, &Elevator::Signal_Available, 10))
            return;
        if (QtMocHelpers::indexOfMethod<void (Elevator::*)(int , int )>(_a, &Elevator::Signal_Arrive, 11))
            return;
    }
}

const QMetaObject *Elevator::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Elevator::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN8ElevatorE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Elevator::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 26)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 26;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 26)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 26;
    }
    return _id;
}

// SIGNAL 0
void Elevator::Signal_MoveUp()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void Elevator::Signal_MoveDown()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void Elevator::Signal_MoveStop()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void Elevator::updateFloorDisplay(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1);
}

// SIGNAL 4
void Elevator::Signal_OpenDoor()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void Elevator::Signal_OpenDoor(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 5, nullptr, _t1);
}

// SIGNAL 6
void Elevator::Signal_CloseDoor()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}

// SIGNAL 7
void Elevator::Signal_RingBell()
{
    QMetaObject::activate(this, &staticMetaObject, 7, nullptr);
}

// SIGNAL 8
void Elevator::Signal_Display(string _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 8, nullptr, _t1);
}

// SIGNAL 9
void Elevator::Signal_Audio(string _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 9, nullptr, _t1);
}

// SIGNAL 10
void Elevator::Signal_Available(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 10, nullptr, _t1);
}

// SIGNAL 11
void Elevator::Signal_Arrive(int _t1, int _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 11, nullptr, _t1, _t2);
}
QT_WARNING_POP
