module xwindow.window;

import x11.X;
import x11.Xlib;

import xwindow.eventloop;

class XWindow
{
private:
    bool visible;
    int screen;

public:
    EventLoop evloop;
    Window window;

    this(EventLoop evloop)
    {
        this.visible = false;
        this.evloop = evloop;
        this.screen = XDefaultScreen(this.evloop.getXDisplay);

        XSetWindowAttributes attributes = void;
        attributes.background_pixel = XWhitePixel(this.evloop.getXDisplay, this.screen);

        this.window = XCreateWindow(this.evloop.getXDisplay, this.evloop.root,
                                    0, 0, 800, 600,
                                    0, 0,
                                    InputOutput, null,
                                    CWBackPixel, &attributes);

        // handling window close.
        auto protocols = [this.evloop.wmDeleteWindow];
        XSetWMProtocols(this.evloop.getXDisplay, this.window, protocols.ptr, 1);
        XFlush(this.evloop.getXDisplay);
    }

    ~this()
    {
        if (visible)
        {
            XUnmapWindow(this.evloop.getXDisplay, this.evloop.root);
            XFlush(this.evloop.getXDisplay);
        }
    }

    void setTitle(string title)
    {
        XStoreName(this.evloop.getXDisplay, this.window, cast(char*) (title ~ "\0").ptr);
    }

    void show()
    {
        XMapRaised(this.evloop.getXDisplay, this.window);
        XFlush(this.evloop.getXDisplay);
        this.visible = true;
    }
}
