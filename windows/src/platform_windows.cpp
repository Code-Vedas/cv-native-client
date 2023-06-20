#include "platform_windows.h"
// This must be included before many other Windows headers.
#include <windows.h>
#include <sstream>
#include <variant>
// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

std::string PlatformWindows::getPlatformVersion()
{
  std::ostringstream version_stream;
  version_stream << "Windows ";
  if (IsWindows10OrGreater())
  {
    version_stream << "10+";
  }
  else if (IsWindows8OrGreater())
  {
    version_stream << "8";
  }
  else if (IsWindows7OrGreater())
  {
    version_stream << "7";
  }
  return version_stream.str();
}