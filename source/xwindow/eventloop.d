module xwindow.eventloop;

import x11.X;
import x11.Xlib;

import xwindow.connection;

class EventLoop
{
    XConnection conn;
    Window root;
    Atom wmDeleteWindow;

    this(XConnection conn)
    {
        this.conn = conn;

        // Hook close request.
        this.wmDeleteWindow = XInternAtom(this.conn.display, "WM_DELETE_WINDOW\0".ptr,
                                          False);

        this.root = XDefaultRootWindow(this.conn.display);
    }

    ~this()
    {
        XDestroyWindow(this.conn.display, this.root);
    }

    XDisplay* getXDisplay() @property
    {
        return this.conn.display;
    }

    void run(bool delegate(XEvent) del)
    {

        XEvent event = void;
        bool running = true;
        while (true)
        {
            XNextEvent(this.conn.display, &event);
            running = del(event);
        }
    }
}
