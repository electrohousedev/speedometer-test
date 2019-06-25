#include "sb_application.h"


class Application : public Sandbox::Application {

};


int StartApplication(int argc,char** argv) {
	Application* app = new Application();
	return GHL_StartApplication(app,argc,argv);
}