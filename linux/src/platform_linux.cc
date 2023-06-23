#include "platform_linux.h"

gchar* PlatformLinux::getPlatformVersion()
{
 struct utsname uname_data = {};
  uname(&uname_data);
  return g_strdup_printf("Linux %s", uname_data.release);
}