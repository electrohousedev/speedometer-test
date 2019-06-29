#ifndef _CONTROLLER_READERS_H_INCLUDED_
#define _CONTROLLER_READERS_H_INCLUDED_

#include "sensors/sensor.h"
#include "controller.h"

namespace controller {
    
    class sensor_reader {
    private:
        const sensors::sensor& m_sensor;
    public:
        explicit sensor_reader(const sensors::sensor& sensor) : m_sensor(sensor) {}
        float read() const { return m_sensor.read(); }
    };
    class value_reader {
    private:
        float_value::cptr m_value;
    public:
        explicit value_reader(const float_value::cptr&& value) : m_value(value) {}
        float read() const { return m_value->get(); }
    };
}

#endif /*_CONTROLLER_READERS_H_INCLUDED_*/

