#ifndef _SENSORS_SENSOR_H_INCLUDED_
#define _SENSORS_SENSOR_H_INCLUDED_

namespace sensors {
   
    class sensor {
        sensor(const sensor&) = delete;
        sensor& operator = (const sensor&) = delete;
    public:
        sensor() = default;
        virtual float read() const = 0;
    };
    
    
}

#endif /*_SENSORS_SENSOR_H_INCLUDED_*/
