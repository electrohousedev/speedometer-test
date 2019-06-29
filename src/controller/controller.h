#ifndef _CONTROLLER_CONTROLLER_H_INCLUDED_
#define _CONTROLLER_CONTROLLER_H_INCLUDED_

#include "value.h"
#include <map>
#include <string>
#include "sensors/sensor.h"
#include "filters.h"

namespace controller {
    
    
    
    
    class controller {
    private:
        
        /// data objects
        template <class DataType>
        class data : public value<DataType> {
        public:
            virtual void update() = 0;
            typedef std::shared_ptr<data> ptr;
        };
        template <class Reader, class Filter, class DataType>
        class value_source : public data<DataType> {
        private:
            Reader m_reader;
            Filter m_filter;
        public:
            value_source(const Reader&& reader, const Filter&& filter) :
            m_reader(reader),
            m_filter(filter) {}
            virtual void update() override final {
                auto sensor_val = m_reader.read();
                this->set( m_filter.apply( sensor_val ) );
            }
        };
        

        std::map<std::string,data<float>::ptr > m_values;
        std::map<std::string,data<bool>::ptr > m_triggers;
        
    public:
        template <class Reader,class Filter>
        void register_value( const char* name, const Reader&& reader, const Filter&& filter ) {
            m_values[name] = std::make_shared< value_source<Reader,Filter,float> > ( std::move(reader), std::move(filter) );
        }
        template <class Reader,class Filter>
        void register_trigger( const char* name, const Reader&& reader, const Filter&& filter ) {
            m_triggers[name] = std::make_shared< value_source<Reader,Filter,bool> > ( std::move(reader), std::move(filter) );
        }
        template <class Reader,class ...Filters>
        void register_value( const char* name, const Reader&& reader, const Filters&& ... filters ) {
            typedef filters_chain<Filters...> filter_chain;
            m_values[name] = std::make_shared< value_source<Reader,filter_chain,float> > ( std::move(reader), filter_chain(std::move(filters)...) );
        }
        
        float_value::cptr get_value(const char* name) const;
        trigger_value::cptr get_trigger(const char* name) const;
        
        /// update data
        void update();
    };
    
}

#endif /*_CONTROLLER_CONTROLLER_H_INCLUDED_*/
