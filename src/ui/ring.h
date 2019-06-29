#ifndef _UI_RING_H_INCLUDED_
#define _UI_RING_H_INCLUDED_

#include <sb_geometry_buffer.h>

namespace ui {
    
    class Ring : public Sandbox::GeometryBuffer {
        SB_META_OBJECT
    private:
        float   m_r_out;
        float   m_r_in;
        
    public:
        Ring();
        void SetROut(float v);
        void SetRIn(float v);
        void Build(size_t steps);
    };
    
}

#endif /*_UI_RING_H_INCLUDED_*/
