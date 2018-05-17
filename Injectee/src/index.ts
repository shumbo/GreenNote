import './style.scss';

// Interrupt existing method
function track(fn: Function, handler: Function) {
  return function interceptor(this: any) {
    handler.apply(this, arguments);
    return fn.apply(this, arguments);
  };
}

enum PageType {
  TOP = 'TOP',
  EDITOR = 'EDITOR',
  OTHER = 'OTHER'
}

class GreenNoteInjectee {
  public currentPage: PageType = PageType.TOP;
  constructor() {
    window.history.pushState = track(
      history.pushState,
      this.handleChangeLocation
    );
    window.history.replaceState = track(
      window.history.replaceState,
      this.handleChangeLocation
    );
  }
  private handleChangeLocation(state: any, title: string, url: string) {
    if (url === '/'){
      this.currentPage = PageType.TOP;
    } else if (url.match(/^\/ddocs\/\d+/)) {
      this.currentPage = PageType.EDITOR;
    } else {
      this.currentPage = PageType.OTHER;
    }
    webkit.messageHandlers.PageType.postMessage(this.currentPage);
  }
}

(window as any)['__GreenNote__'] = new GreenNoteInjectee();

// Map TouchEvent to ClickEvent
document.addEventListener('touchstart', (e: TouchEvent) => {
  if (e.changedTouches.length > 1) {
    return;
  }
  const touch = e.changedTouches[0];
  const eventToSimulate = document.createEvent('MouseEvent');
  eventToSimulate.initMouseEvent(
    'mousedown',
    true,
    true,
    window,
    1,
    touch.screenX,
    touch.screenY,
    touch.clientX,
    touch.clientY,
    false,
    false,
    false,
    false,
    0,
    null
  );
  touch.target.dispatchEvent(eventToSimulate);
  e.preventDefault();
}, true);