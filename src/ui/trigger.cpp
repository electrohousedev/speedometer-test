#include "trigger.h"
#include <sb_graphics.h>

SB_META_DECLARE_OBJECT(ui::Trigger, Sandbox::Container)

namespace ui {
    
    Trigger::Trigger( const  controller::trigger_value::cptr& sensor ) :
        m_sensor(sensor),
        m_visible_value(true) {}
    
    void Trigger::Draw( Sandbox::Graphics& g ) const {
        if (m_sensor->get() == m_visible_value) {
            Sandbox::Container::Draw(g);
        }
    }
    
}

