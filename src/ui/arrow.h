#ifndef _UI_ARROW_H_ICNLUDED_
#define _UI_ARROW_H_ICNLUDED_

#include <sb_container.h>
#include "controller/value.h"

namespace ui {
    
    class Arrow : public Sandbox::Container {
        SB_META_OBJECT;
    private:
        controller::float_value::cptr m_sensor;
        float m_scale;
    public:
        explicit Arrow( const  controller::float_value::cptr& sensor );
        void Update( float dt ) override;
        void SetValueScale(float s) { m_scale = s; }
        float GetValueScale() const { return m_scale; }
    };
}

#endif /*_UI_ARROW_H_ICNLUDED_*/


