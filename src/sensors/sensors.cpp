#include "sensors.h"
#include "generator.h"
#include <thread>
#include <atomic>
#include <mutex>

namespace sensors {
    
    
    template <class Storage>
    class sensor_impl : public sensor {
    private:
        Storage m_storage;
    protected:
        sensor_impl() = default;
        void set(float val) { m_storage.set(val); }
        virtual float read() const override final { return m_storage.get(); }
    };
    
    template <class Storage>
    class sensor_service : public sensor_impl<Storage> {
    private:
        volatile bool m_started;
        std::thread m_thread;
        using sensor_impl<Storage>::set;
    protected:
        
        template <class Generator>
        void run_servive(Generator& generator) {
            while (m_started) {
                float val = generator.gen(clock::now());
                set(val);
                std::this_thread::sleep_for(std::chrono::microseconds(100));
            }
        }
        
        sensor_service( ) : m_started(true),m_thread() {
           
        }
        
        template <typename ...FuncArgs>
        void start( FuncArgs...args ) {
             m_thread = std::thread( args... );
        }
      
    public:
        ~sensor_service() {
            m_started = false;
            m_thread.join();
        }
    };
    
    struct automic_storage {
        std::atomic<float> m_value;
        void set(float v) { m_value = v; }
        float get() const { return m_value; }
    };
    
    class speed_service : public sensor_service<automic_storage> {
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
        speed_service() {
            start(&speed_service::thread_func,this);
        }
    };
    
    static speed_service speed_sensor;
    
    const sensor& get_speed_sensor() {
        return speed_sensor;
    }
    
    
    struct sync_storage {
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
    
    class engine_service : public sensor_service<sync_storage> {
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
        engine_service() {
            start(&engine_service::thread_func,this);
        }
    };
    
    static engine_service engine_sensor;
    
    const sensor& get_engine_sensor() {
        return engine_sensor;
    }
}
