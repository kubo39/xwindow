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
        this.wmDeleteWindow = XInternAtom(this.conn.display, WM_DELETE_WINDOW.ptr,
                                          False);

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

    void run(bool delegate(XEvent) del)
    {

        XEvent event = void;
        bool running = true;
        while (true)
        {
            XNextEvent(this.conn.display, &event);
            running = processEvent(event, del);
        }
    }

    bool processEvent(XEvent event, bool delegate(XEvent) del)
    {
        auto wmProtocols = XInternAtom(this.getXDisplay, WM_PROTOCOL.ptr, False);

        switch (event.type)
        {
        case ClientMessage:
            auto xclient = event.xclient;
            if (xclient.message_type == wmProtocols && xclient.format == 32)
            {
                auto protocol = cast(Atom) xclient.data.l[0];
                if (protocol == this.wmDeleteWindow)
                    return false;
            }
            break;
        default:
            // nop
        }
        return del(event);
    }
}
