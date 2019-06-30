#ifndef _SENSORS_STORAGE_H_INCLUDED_
#define _SENSORS_STORAGE_H_INCLUDED_

#include <atomic>
#include <mutex>

namespace sensors {
    
    struct automic_storage {
        std::atomic<float> m_value;
        void set(float v) { m_value = v; }
        float get() const { return m_value; }
    };
    
    struct mutex_storage {
        float m_value;
        mutable std::mutex m;
        void set(float v) {
            std::lock_guard<std::mutex> guard(m);
            m_value = v;
        }
        float get() const {
            std::lock_guard<std::mutex> guard(m);
            return m_value;
        }
    };
}

#endif /*_SENSORS_STORAGE_H_INCLUDED_*/

