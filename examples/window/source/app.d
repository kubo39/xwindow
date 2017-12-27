import xwindow;

import std.conv : to;

import x11.X;
import x11.Xlib;

void main()
{
    auto xConn = new XConnection;
    auto evloop = new EventLoop(xConn);
    auto window = new XWindow(evloop);

    window.setTitle("Test");
    window.show();


    evloop.run((event) {
            auto wmProtocols = XInternAtom(evloop.getXDisplay, "WM_PROTOCOL\0".ptr, False);
            auto wmDeleteWindow = XInternAtom(evloop.getXDisplay, "WM_DELETE_WINDOW\0".ptr, False);
            auto protocols = [wmDeleteWindow];
            XSetWMProtocols(evloop.getXDisplay, window.window, protocols.ptr, protocols.length.to!int);

            switch (event.type)
            {
            case ClientMessage:
                auto xclient = event.xclient;

                if (xclient.message_type == wmProtocols && xclient.format == 32)
                {
                    auto protocol = cast(Atom) xclient.data.l[0];
                    if (protocol == wmDeleteWindow)
                        return false;
                }
                break;
            default:
                // nop
            }
            return true;
        });
}
