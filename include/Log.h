#ifndef VEGA_LOG_H
#define VEGA_LOG_H

#include <string>

namespace vega
{
	class Log
	{
	public:
		static void Info(std::string);
		static void Error(std::string);
	};
}

#endif
