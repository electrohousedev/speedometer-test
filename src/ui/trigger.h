#ifndef _UI_TRIGGER_H_ICNLUDED_
#define _UI_TRIGGER_H_ICNLUDED_

#include <sb_container.h>
#include "controller/value.h"

namespace ui {
    
    class Trigger : public Sandbox::Container {
        SB_META_OBJECT;
    private:
        controller::trigger_value::cptr m_sensor;
        bool m_visible_value;
    public:
        explicit Trigger( const  controller::trigger_value::cptr& sensor );
        void Draw( Sandbox::Graphics& g ) const override;
        void SetVisibleValue(bool s) { m_visible_value = s; }
        bool GetVisibleValue() const { return m_visible_value; }
    };
}

#endif /*_UI_TRIGGER_H_ICNLUDED_*/



