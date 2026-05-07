/****************************************************************************
** Meta object code from reading C++ file 'floor_button.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../floor_button.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'floor_button.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN11FloorButtonE_t {};
} // unnamed namespace

template <> constexpr inline auto FloorButton::qt_create_metaobjectdata<qt_meta_tag_ZN11FloorButtonE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "FloorButton",
        "floorRequestUp",
        "",
        "floor",
        "floorRequestDown",
        "Signal_LightsUp",
        "up",
        "Signal_LightsOff",
        "press1Up",
        "press2Up",
        "press2Down",
        "press3Up",
        "press3Down",
        "press4Up",
        "press4Down",
        "press5Up",
        "press5Down",
        "press6Up",
        "press6Down",
        "press7Down",
        "lightsOff"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'floorRequestUp'
        QtMocHelpers::SignalData<void(int)>(1, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 3 },
        }}),
        // Signal 'floorRequestDown'
        QtMocHelpers::SignalData<void(int)>(4, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 3 },
        }}),
        // Signal 'Signal_LightsUp'
        QtMocHelpers::SignalData<void(int, bool)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 3 }, { QMetaType::Bool, 6 },
        }}),
        // Signal 'Signal_LightsOff'
        QtMocHelpers::SignalData<void(int, bool)>(7, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 3 }, { QMetaType::Bool, 6 },
        }}),
        // Slot 'press1Up'
        QtMocHelpers::SlotData<void()>(8, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'press2Up'
        QtMocHelpers::SlotData<void()>(9, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'press2Down'
        QtMocHelpers::SlotData<void()>(10, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'press3Up'
        QtMocHelpers::SlotData<void()>(11, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'press3Down'
        QtMocHelpers::SlotData<void()>(12, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'press4Up'
        QtMocHelpers::SlotData<void()>(13, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'press4Down'
        QtMocHelpers::SlotData<void()>(14, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'press5Up'
        QtMocHelpers::SlotData<void()>(15, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'press5Down'
        QtMocHelpers::SlotData<void()>(16, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'press6Up'
        QtMocHelpers::SlotData<void()>(17, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'press6Down'
        QtMocHelpers::SlotData<void()>(18, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'press7Down'
        QtMocHelpers::SlotData<void()>(19, 2, QMC::AccessPublic, QMetaType::Void),
        // Slot 'lightsOff'
        QtMocHelpers::SlotData<void(int, bool)>(20, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 3 }, { QMetaType::Bool, 6 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<FloorButton, qt_meta_tag_ZN11FloorButtonE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject FloorButton::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11FloorButtonE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11FloorButtonE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN11FloorButtonE_t>.metaTypes,
    nullptr
} };

void FloorButton::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<FloorButton *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->floorRequestUp((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 1: _t->floorRequestDown((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 2: _t->Signal_LightsUp((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<bool>>(_a[2]))); break;
        case 3: _t->Signal_LightsOff((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<bool>>(_a[2]))); break;
        case 4: _t->press1Up(); break;
        case 5: _t->press2Up(); break;
        case 6: _t->press2Down(); break;
        case 7: _t->press3Up(); break;
        case 8: _t->press3Down(); break;
        case 9: _t->press4Up(); break;
        case 10: _t->press4Down(); break;
        case 11: _t->press5Up(); break;
        case 12: _t->press5Down(); break;
        case 13: _t->press6Up(); break;
        case 14: _t->press6Down(); break;
        case 15: _t->press7Down(); break;
        case 16: _t->lightsOff((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<bool>>(_a[2]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (FloorButton::*)(int )>(_a, &FloorButton::floorRequestUp, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloorButton::*)(int )>(_a, &FloorButton::floorRequestDown, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloorButton::*)(int , bool )>(_a, &FloorButton::Signal_LightsUp, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (FloorButton::*)(int , bool )>(_a, &FloorButton::Signal_LightsOff, 3))
            return;
    }
}

const QMetaObject *FloorButton::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *FloorButton::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN11FloorButtonE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int FloorButton::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 17)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 17;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 17)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 17;
    }
    return _id;
}

// SIGNAL 0
void FloorButton::floorRequestUp(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 0, nullptr, _t1);
}

// SIGNAL 1
void FloorButton::floorRequestDown(int _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1);
}

// SIGNAL 2
void FloorButton::Signal_LightsUp(int _t1, bool _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1, _t2);
}

// SIGNAL 3
void FloorButton::Signal_LightsOff(int _t1, bool _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1, _t2);
}
QT_WARNING_POP
