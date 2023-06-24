// MIT License
//
// Copyright (c) 2023 Code Vedas
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
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