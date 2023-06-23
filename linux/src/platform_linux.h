#pragma once
#include <sys/utsname.h>
#include <gtk/gtk.h>

// class PlatformLinux
class PlatformLinux
{
public:
  static gchar* getPlatformVersion();
};