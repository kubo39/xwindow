module xwindow.connection;

import x11.X;
import x11.Xlib;

class XConnection
{
    XDisplay* display;

    this()
    {
        this.display = XOpenDisplay(null);
        assert(this.display !is null, "XOpenDisplay failed.");
    }

    ~this()
    {
        if (this.display !is null)
            XCloseDisplay(this.display);
    }
}
