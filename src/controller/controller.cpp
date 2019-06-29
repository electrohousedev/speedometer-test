#include "controller.h"


namespace controller {
    
    
    float_value::cptr controller::get_value(const char* name) const {
        auto it = m_values.find( name );
        return it == m_values.end() ? float_value::cptr() : it->second;
    }
    trigger_value::cptr controller::get_trigger(const char* name) const {
        auto it = m_triggers.find( name );
        return it == m_triggers.end() ? trigger_value::cptr() : it->second;
    }
    
    void controller::update() {
        for (auto& v:m_values) {
            v.second->update();
        }
        for (auto& t:m_triggers) {
            t.second->update();
        }
    }
    
}
