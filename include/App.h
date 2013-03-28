#ifndef VEGA_APP_H
#define VEGA_APP_H

#include "VegaDefines.h"
#include <string>

namespace vega
{
	/**
	The entry point class. Create an instance and execute with a Lua script calling the Execute function.
	*/
	class App
	{
	public:
		App();
		virtual ~App();
		void Execute(std::string scriptName);

	private:
		void RequireScript(std::string scriptName);
	};
}

#ifdef VEGA_WINDOWS
#define EXECUTE_APP(scriptName) \
	int main(int argc, char** argv) \
	{ \
		vega::App app; \
		app.Execute(scriptName); \
		return 0; \
	}
#endif

#endif
