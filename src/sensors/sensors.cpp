#include "sensors.h"
#include "generator.h"
#include "storage.h"
#include <thread>


namespace sensors {
    
    template <class Storage>
    class sensor_impl : public sensor {
    private:
        Storage m_storage;
        volatile bool m_started;
        std::thread m_thread;
    protected:
        
        sensor_impl( ) : m_started(true),m_thread() {
            
        }
        
        template <class Generator>
        void run_servive(Generator& generator) {
            while (m_started) {
                float val = generator.gen(clock::now());
                m_storage.set(val);
                std::this_thread::sleep_for(std::chrono::microseconds(100));
            }
        }
        
        template <typename ...FuncArgs>
        void start( FuncArgs...args ) {
             m_thread = std::thread( args... );
        }
      
    public:
        
        virtual float read() const override final { return m_storage.get(); }
        
        ~sensor_impl() {
            m_started = false;
            m_thread.join();
        }
    };
    
    
    
    class speed_sensor : public sensor_impl<automic_storage> {
        void thread_func() {
            auto gen = generator(
                           const_gen(100.0f),
                           sin_gen(100,std::chrono::seconds(17)),
                           sin_gen(50,std::chrono::seconds(29)),
                           sin_gen(40,std::chrono::seconds(3))
                           );
            run_servive(gen);
        }
    public:
        speed_sensor() {
            start(&speed_sensor::thread_func,this);
        }
    };
    
    static speed_sensor s_speed_sensor;
    
    const sensor& get_speed_sensor() {
        return s_speed_sensor;
    }
    
    class engine_sensor : public sensor_impl<mutex_storage> {
        void thread_func() {
            auto gen = generator(
                                 const_gen(5650),
                                 sin_gen(5000,std::chrono::seconds(11)),
                                 sin_gen(500,std::chrono::seconds(3)),
                                 sin_gen(150,std::chrono::seconds(5))
                                 );
            run_servive(gen);
        }
    public:
        engine_sensor() {
            start(&engine_sensor::thread_func,this);
        }
    };
    
    static engine_sensor s_engine_sensor;
    
    const sensor& get_engine_sensor() {
        return s_engine_sensor;
    }
}
