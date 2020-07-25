import x11/xlib,
       x11/x

var 
  display*: PDisplay

  attr*: XWindowAttributes
  start*:  XButtonEvent
  event*: XEvent

proc resizeWindow* = 
  let xdiff = event.xbutton.x_root - start.x_root
  let ydiff = event.xbutton.y_root - start.y_root
  discard XMoveResizeWindow(display, start.subwindow,
                    attr.x + (if start.button == 1: xdiff else: 0).cint,
                    attr.y + (if start.button == 1: ydiff else: 0).cint,
                    max(1, attr.width + (if start.button == 3: xdiff else: 0)).cuint,
                    max(1, attr.height + (if start.button == 3: ydiff else: 0)).cuint)
