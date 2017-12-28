import xwindow;

void main()
{
    auto evloop = new EventLoop();
    auto window = new XWindow(evloop);

    window.setTitle("Test");
    window.show();

    evloop.run((event) {
            if (event.type == WindowEventType.Closed)
                return false;
            return true;
        });
}
