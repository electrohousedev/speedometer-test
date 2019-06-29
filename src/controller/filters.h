#ifndef _CONTROLLER_FILTERS_H_INCLUDED_
#define _CONTROLLER_FILTERS_H_INCLUDED_

#include <algorithm>
#include <cmath>

namespace controller {
    
    /// limit value
    class limit_filer {
    private:
        float m_min;
        float m_max;
    public:
        limit_filer(float min,float max) : m_min(min),m_max(max) {}
        float apply(float v) const {
            return std::min(m_max,std::max(m_min,v));
        }
    };
    /// absolut value
    class absolute {
    public:
        float apply(float v) const {
            return std::abs(v);
        }
    };
    /// value bigger level make triger active
    class level_trigger {
    private:
        float m_level;
    public:
        explicit level_trigger(float level) : m_level(level) {}
        bool apply(float v) const {
            return v > m_level;
        }
    };
    /// c++11 dnt have traits for member function
    template <typename T>
    struct filter_result;
    template <typename R,typename T,typename U>
    struct filter_result<R(T::*)(U)const> {
        typedef R type;
    };
    /// chain filters
    template <typename ...Filters>
    class filters_chain;
    template <class Head,class ...Rest> class filters_chain<Head,Rest...>{
    private:
        Head m_head;
        filters_chain<Rest...> m_tail;
    public:
        filters_chain(const Head&& f,const Rest&& ... l) : m_head(std::move(f)),m_tail(std::move(l)...) {}
        typename filter_result<decltype(&filters_chain<Rest...>::apply)>::type apply(float v) const {
            return m_tail.apply(m_head.apply(v));
        }
    };
    template <class Head,class Last> class filters_chain<Head,Last>{
    private:
        Head m_head;
        Last m_last;
    public:
        filters_chain(const Head&& f,const Last&& l) : m_head(std::move(f)),m_last(std::move(l)) {}
        typename filter_result<decltype(&Last::apply)>::type apply(float v) const {
            return m_last.apply(m_head.apply(v));
        }
    };
    
}

#endif /*_CONTROLLER_FILTERS_H_INCLUDED_*/
