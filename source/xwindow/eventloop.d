module xwindow.eventloop;

import x11.X;
import x11.Xlib;

import xwindow.connection;

enum WM_DELETE_WINDOW = "WM_DELETE_WINDOW\0";
enum WM_PROTOCOL = "WM_PROTOCOL\0";


class EventLoop
{
private:
    XConnection conn;

public:
    Window root;
    Atom wmDeleteWindow;

    this(XConnection conn)
    {
        this.conn = conn;

        // Hook close request.
        this.wmDeleteWindow = XInternAtom(this.conn.display, WM_DELETE_WINDOW.ptr, False);
        this.root = XDefaultRootWindow(this.conn.display);
    }

    this()
    {
        this(new XConnection);
    }

    ~this()
    {
        XDestroyWindow(this.conn.display, this.root);
    }

    XDisplay* getXDisplay() @property
    {
        return this.conn.display;
    }

    void run(bool delegate(Event) del)
    {

        XEvent event;
        bool running = true;
        while (running)
        {
            XNextEvent(this.conn.display, &event);
            running = processEvent(event, del);
        }
    }

    bool processEvent(XEvent event, bool delegate(Event) del)
    {
        auto wid = event.xany.window;

        switch (event.type)
        {
        case ClientMessage:
            if (cast(Atom) event.xclient.data.l[0] == this.wmDeleteWindow)
            {
                XSetCloseDownMode(this.getXDisplay, CloseDownMode.DestroyAll);
                return del(Event(wid, WindowEventType.Closed));
            }
            break;
        case DestroyNotify:
            XSetCloseDownMode(this.getXDisplay, CloseDownMode.DestroyAll);
            return del(Event(wid, WindowEventType.Closed));
        default:
            // nop
        }
        return del(Event(wid, WindowEventType.Undefined));
    }
}


struct Event
{
    Window wid;
    WindowEventType type;

    this(Window wid, WindowEventType type)
    {
        this.wid = wid;
        this.type = type;
    }
}

enum WindowEventType
{
    Closed,
    Undefined,
}
