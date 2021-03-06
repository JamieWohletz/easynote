// Generated by CoffeeScript 1.6.3
(function() {
  window.Notebook = (function() {
    Notebook.CANVAS = null;

    Notebook.currentPage = null;

    Notebook.pages = null;

    Notebook.CURRENT_PAGE_KEY = null;

    Notebook.NOTEBOOK_KEY = null;

    function Notebook(canvas) {
      this.CURRENT_PAGE_KEY = 'easynote_currentPage';
      this.NOTEBOOK_KEY = 'easynote_notebook';
      this.CANVAS = canvas;
      this.currentPage = 0;
      this.pages = [];
      if (!this.restoreState()) {
        this.pages.push(this.CANVAS.getCanvas().toDataURL('image/png'));
      }
    }

    Notebook.prototype.getCurrentPageIndex = function() {
      return this.currentPage + 1;
    };

    Notebook.prototype.nextPage = function() {
      this.savePage();
      if (this.currentPage === this.pages.length - 1) {
        this.pages.push(null);
      }
      this.currentPage++;
      return this.loadPage();
    };

    Notebook.prototype.previousPage = function() {
      if (this.currentPage !== 0) {
        this.savePage();
        this.currentPage--;
        return this.loadPage();
      }
    };

    Notebook.prototype.savePage = function() {
      return this.pages[this.currentPage] = this.CANVAS.getCanvas().toDataURL('image/png');
    };

    Notebook.prototype.loadPage = function() {
      var ctx, dataURL, img, old,
        _this = this;
      this.CANVAS.destroyChildren();
      this.CANVAS.clear();
      if (this.pages[this.currentPage] === null) {
        return;
      }
      ctx = this.CANVAS.context;
      old = {};
      old.operation = ctx.globalCompositeOperation;
      old.strokeStyle = ctx.strokeStyle;
      ctx.globalCompositeOperation = 'source-over';
      ctx.strokeStyle = 'black';
      dataURL = this.pages[this.currentPage];
      img = new Image;
      img.onload = function() {
        ctx.drawImage(img, 0, 0, _this.CANVAS.getCanvas().width, _this.CANVAS.getCanvas().height);
        ctx.globalCompositeOperation = old.operation;
        return ctx.strokeStyle = old.strokeStyle;
      };
      return img.src = dataURL;
    };

    Notebook.prototype.saveState = function() {
      if (typeof window.localStorage !== 'object') {
        return;
      }
      this.savePage();
      localStorage[this.CURRENT_PAGE_KEY] = this.currentPage;
      return localStorage[this.NOTEBOOK_KEY] = JSON.stringify(this.pages);
    };

    Notebook.prototype.restoreState = function() {
      if (typeof window.localStorage !== 'object' || (localStorage[this.NOTEBOOK_KEY] == null) || (localStorage[this.CURRENT_PAGE_KEY] == null)) {
        return false;
      }
      this.pages = JSON.parse(localStorage[this.NOTEBOOK_KEY]);
      this.currentPage = parseInt(localStorage[this.CURRENT_PAGE_KEY]);
      this.loadPage();
      return true;
    };

    return Notebook;

  })();

}).call(this);
