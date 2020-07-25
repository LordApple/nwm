import x11/xlib,
       x11/x
import ./utils

proc setup =
  display = XOpenDisplay(nil)
  if display == nil:
    quit "Could not open display"

  discard XGrabKey(display, XKeysymToKeycode(display, XStringToKeysym("F1")).cint, Mod1Mask,
                   DefaultRootWindow(display), 1, GrabModeAsync, GrabModeAsync)

  discard XGrabButton(display, 1, Mod1Mask, DefaultRootWindow(display), 1,
                      ButtonPressMask or ButtonReleaseMask or PointerMotionMask,
                      GrabModeAsync, GrabModeAsync, None, None)

  discard XGrabButton(display, 3, Mod1Mask, DefaultRootWindow(display), 1,
                      ButtonPressMask or ButtonReleaseMask or PointerMotionMask,
                      GrabModeAsync, GrabModeAsync, None, None)

  start.subwindow = None

proc mainLoop =
  while true:
    discard XNextEvent(display, addr event)

    if event.theType == KeyPress:
      discard XRaiseWindow(display, event.xkey.subwindow)
    elif event.theType == ButtonPress and event.xbutton.subwindow != None:
      discard XGetWindowAttributes(display, event.xbutton.subwindow, addr attr)
      start = event.xbutton
    elif event.theType == MotionNotify and start.subwindow != None:
      resizeWindow()
    elif event.theType == ButtonRelease:
      start.subwindow = None


proc main =
  setup()
  mainLoop()

main()
