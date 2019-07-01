#ifndef _GENERATOR_H_INCLUDED_
#define _GENERATOR_H_INCLUDED_

#include <chrono>
#include <cmath>

namespace sensors {

	typedef std::chrono::high_resolution_clock clock;
	typedef std::chrono::time_point<clock> time_point;

	class sin_gen {
    private:
        time_point m_start;
        const float m_scale;
        const clock::duration m_period;
    public:
        sin_gen( float scale, const clock::duration&& period );
        float gen( const time_point& now );
	};
    
    class const_gen {
    private:
        float m_value;
    public:
        const_gen( float v ) : m_value(v) {}
        float gen( const time_point& now ) {return m_value;}
    };

	template <typename ... Rest>
	class gen_seq;

	template <typename Last>
	class gen_seq<Last> {
		Last m_gen;
	public:
		explicit gen_seq( Last&& last ) : m_gen(last) {

		}
		float gen( const time_point& now )  {
			return m_gen.gen(now);
		}
	};

	template <typename First, typename ... Rest>
	class gen_seq<First,Rest ...> {
		First m_gen;
		gen_seq<Rest ... > m_rest;
	public:
		explicit gen_seq( First&& first , Rest&& ... rest) : 
			m_gen( first ),m_rest( std::move(rest)... ) {

		}
		float gen( const time_point& now )  {
			return m_gen.gen(now) + m_rest.gen( now );
		}
	};


	

	template <class ... Parts>
	static inline auto generator(Parts&& ... parts) -> gen_seq<Parts...> {
        // good explanation why need forward there http://bajamircea.github.io/coding/cpp/2016/04/07/move-forward.html
		return gen_seq<Parts ... >{ std::forward<Parts>(parts)... };
	};

}

#endif /*_GENERATOR_H_INCLUDED_*/

