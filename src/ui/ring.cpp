#include "ring.h"

SB_META_DECLARE_OBJECT(ui::Ring, Sandbox::GeometryBuffer)

namespace ui {
    
    
    Ring::Ring() : m_r_out(200), m_r_in(100) {}
    
    void Ring::SetROut(float v) {
        m_r_out = v;
    }
    
    void Ring::SetRIn(float v) {
        m_r_in = v;
    }
    
    void Ring::Build( size_t steps ) {
        if (!GetImage())
            return;
        Sandbox::Image img(*GetImage());
        
        Sandbox::GeometryData& buffer(GetData());
        buffer.primitives = GHL::PRIMITIVE_TYPE_TRIANGLES;
        
        float as = M_PI * 2 / steps;
        float a = 0.0f;
        
        ++steps;
        
        buffer.texture = img.GetTexture();
        buffer.vertexes.clear();
        buffer.indexes.clear();
        buffer.vertexes.reserve(steps*2);
        buffer.indexes.reserve(steps*6);
        
        float tx = img.GetTexture() ? (img.GetTextureX() / img.GetTexture()->GetWidth()) : 0.0f;
        float ty = img.GetTexture() ? (img.GetTextureY() / img.GetTexture()->GetHeight()) : 0.0f;
        float tw = img.GetTexture() ? (img.GetTextureW() / img.GetTexture()->GetWidth()) : 1.0f;
        float th = img.GetTexture() ? (img.GetTextureH() / img.GetTexture()->GetHeight()) : 1.0f;
        
        Sandbox::Vector2f uv_in(tx+tw,ty+th*0.5f);
        Sandbox::Vector2f uv_out(tx,ty+th*0.5f);
        
        
        size_t base = 0;
        
        GHL::UInt32 clr = GetColor().hw_premul();
        for (size_t i=0;i<steps;++i) {
            Sandbox::Vector2f in_pos(m_r_in,0.0f);
            in_pos.rotate(a);
            Sandbox::Vector2f out_pos(m_r_out,0.0f);
            out_pos.rotate(a);
            buffer.AddVertex(out_pos, uv_out, clr);
            buffer.AddVertex(in_pos, uv_in, clr);
            if (i) {
                buffer.AddTriangle(base, base+2, base+1);
                buffer.AddTriangle(base+1, base+2, base+3);
                base += 2;
            }
            a += as;
        }
        
    }
    
}
