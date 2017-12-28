import xwindow;

void main()
{
    auto evloop = new EventLoop();
    auto window = new XWindow(evloop);

    window.setTitle("Test");
    window.show();

    evloop.run((event) {
            return true;
        });
}
