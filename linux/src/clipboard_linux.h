#pragma once
#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

// class ClipboardLinux
class ClipboardLinux
{
public:
    static char kMimeTextPlain[]; // = "text/plain";
    static char kMimeTextHtml[];  // = "text/html";

    static char kPlainText[];         // = "plainText";
    static char kHtmlText[];          // = "htmlText";
    static GdkAtom kGdkAtomTextPlain; // = gdk_atom_intern_static_string("text/plain");
    static GdkAtom kGdkAtomTextHtml;  // = gdk_atom_intern_static_string(kMimeTextHtml);

    static guint kUserInfoTextPlain; // = 1;
    static guint kUserInfoTextHtml;  // = 2;

    /// @brief Get clipboard data
    /// @return FlValue* - map with keys "plainText" and "htmlText"
    static FlValue *getClipboardData();

    /// @brief Get clipboard data mime types
    /// @return FlValue* - list with mime types "plainText" and "htmlText"
    /// - "plainText" - text/plain mime type (If clipboard contains plain text)
    /// - "htmlText" - text/html mime type (If clipboard contains html text)
    static FlValue *getClipboardDataMimeTypes();

    /// @brief Set clipboard data
    /// @param method_call - method call
    /// @return bool - true if success
    static bool setClipboardData(FlMethodCall *method_call);
};