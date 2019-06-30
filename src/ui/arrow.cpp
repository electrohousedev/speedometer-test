#include "arrow.h"
#include <sb_graphics.h>

SB_META_DECLARE_OBJECT(ui::Arrow, Sandbox::Container)

namespace ui {
    
    Arrow::Arrow( const  controller::float_value::cptr& sensor ) :
        m_sensor(sensor)
        ,m_scale(1.0f) {}
    void Arrow::Update( float dt ) {
        SetAngle( m_sensor->get() * m_scale );
    }
                       
}
