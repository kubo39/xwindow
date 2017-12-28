module xwindow.connection;

import std.exception : enforce;

import x11.X;
import x11.Xlib;

class XConnection
{
    XDisplay* display;

    this()
    {
        this.display = enforce(XOpenDisplay(null), "XOpenDisplay failed.");
    }

    ~this()
    {
        XCloseDisplay(this.display);
    }
}
