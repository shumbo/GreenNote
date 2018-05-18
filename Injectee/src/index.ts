import './style.scss';

const $ = (q: string) => document.querySelector(q);
const $$ = (q: string) => document.querySelectorAll(q);

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

  // Handle change in URL and notify to the ViewController
  private handleChangeLocation(state: any, title: string, url: string) {
    if (url === '/') {
      this.currentPage = PageType.TOP;
    } else if (url.match(/^\/ddocs\/\d+/)) {
      this.currentPage = PageType.EDITOR;
    } else {
      this.currentPage = PageType.OTHER;
    }
    webkit.messageHandlers.PageType.postMessage(this.currentPage);
  }

  // Create a new document with text
  public createDocument(title: string, str: string) {
    window.history.pushState(null, undefined, '/docs/new');
    const editor = $('.ql-editor');
    if (!editor) {
      return;
    }
    editor.innerHTML = str;
  }

  // Read document
  public getDocument() {
    const titleInput = $('[data-name="title-input"]') as HTMLInputElement;
    const editor = $('.ql-editor');
    if (!titleInput || !editor) {
      return;
    }
    const title = titleInput.value;
    const content = editor.innerHTML;
    return JSON.stringify({ title, content });
  }
}

(window as any)['__GreenNote__'] = new GreenNoteInjectee();

// Map TouchEvent to ClickEvent
document.addEventListener(
  'touchstart',
  (e: TouchEvent) => {
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
  },
  true
);
