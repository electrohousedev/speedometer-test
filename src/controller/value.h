#ifndef _CONTROLLER_VALUE_H_INCLUDED_
#define _CONTROLLER_VALUE_H_INCLUDED_

#include <memory>

namespace controller {
    
    template <class T>
    class value {
    private:
        T   m_value;
    protected:
        void set( T v ) { m_value = v; }
    public:
        T get() const { return m_value; }
        typedef std::shared_ptr<const value> cptr;
    };
    
    typedef value<float> float_value;
    typedef value<bool> trigger_value;
}

#endif /*_CONTROLLER_VALUE_H_INCLUDED_*/
