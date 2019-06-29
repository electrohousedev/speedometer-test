#include "generator.h"

namespace sensors {

	sin_gen::sin_gen( float scale, const clock::duration&& period ) :
		m_start(clock::now()),m_scale(scale),m_period(period) {

	}
 	float sin_gen::gen( const time_point& now ) {
 		auto dt = now - m_start;
 		if (dt > m_period) {
 			m_start += m_period;
 		}
 		auto t = std::chrono::duration_cast<std::chrono::duration<float> >(dt).count() /
                std::chrono::duration_cast<std::chrono::duration<float> >(m_period).count();
		return m_scale * std::sinf( t * 2.0f * M_PI );
	}

}
