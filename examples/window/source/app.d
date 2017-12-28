import xwindow;

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
            return false; // break eventloop.
        });
}
