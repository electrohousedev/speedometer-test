#include "sb_application.h"

#include "controller/controller.h"
#include "controller/filters.h"
#include "controller/readers.h"

#include "sensors/sensors.h"
#include "ui/arrow.h"
#include "ui/ring.h"
#include "ui/trigger.h"

class Application : public Sandbox::Application {
    SB_META_OBJECT;
private:
    controller::controller m_controller;
public:
    Application() {
        SetClearColor(Sandbox::Color(0,0,0,0));
        SetTitle("Speedometer");
        m_controller.register_value("speedometer",
                                    controller::sensor_reader(sensors::get_speed_sensor()),
                                    controller::limit_filer(-50.0,250.0),
                                    controller::absolute()
                                    );
        m_controller.register_value("tachometer",
                                    controller::sensor_reader(sensors::get_engine_sensor()),
                                    controller::limit_filer(0.0,10000.0)
                                    );
        m_controller.register_trigger("tachometer",
                                      controller::value_reader(m_controller.get_value("tachometer")),
                                      controller::level_trigger(7000)
                                      );
    }
    
    virtual void Update(float dt) override {
        m_controller.update();
        Sandbox::Application::Update(dt);
    }
    
    sb::intrusive_ptr<ui::Arrow> create_arrow( const char* name ) const {
        controller::float_value::cptr sensor = m_controller.get_value( name );
        if (!sensor) {
            return sb::intrusive_ptr<ui::Arrow>();
        }
        return sb::intrusive_ptr<ui::Arrow>(new ui::Arrow(sensor));
    }
    sb::intrusive_ptr<ui::Trigger> create_trigger( const char* name ) const {
        controller::trigger_value::cptr sensor = m_controller.get_trigger(name);
        if (!sensor) {
            return sb::intrusive_ptr<ui::Trigger>();
        }
        return sb::intrusive_ptr<ui::Trigger>(new ui::Trigger(sensor));
    }
    void BindModules( Sandbox::LuaVM* lua ) override;
};


SB_META_DECLARE_OBJECT(::Application,Sandbox::Application)
SB_META_BEGIN_KLASS_BIND(::Application)
SB_META_METHOD(create_arrow)
SB_META_METHOD(create_trigger)
SB_META_END_KLASS_BIND()

SB_META_BEGIN_KLASS_BIND(ui::Arrow)
SB_META_PROPERTY_RW_DEF(ValueScale)
SB_META_END_KLASS_BIND()

SB_META_BEGIN_KLASS_BIND(ui::Trigger)
SB_META_PROPERTY_RW_DEF(VisibleValue)
SB_META_END_KLASS_BIND()

SB_META_BEGIN_KLASS_BIND(ui::Ring)
SB_META_CONSTRUCTOR(())
SB_META_PROPERTY_WO(ROut, SetROut)
SB_META_PROPERTY_WO(RIn, SetRIn)
SB_META_METHOD(Build)
SB_META_END_KLASS_BIND()

void Application::BindModules(Sandbox::LuaVM *lua) {
    Sandbox::Application::BindModules(lua);
    Sandbox::luabind::ExternClass<Application>(lua->GetVM());
    Sandbox::luabind::ExternClass<ui::Arrow>(lua->GetVM());
    Sandbox::luabind::ExternClass<ui::Trigger>(lua->GetVM());
    Sandbox::luabind::Class<ui::Ring>(lua->GetVM());
}


int StartApplication(int argc,char** argv) {
	Application* app = new Application();
	return GHL_StartApplication(app,argc,argv);
}
