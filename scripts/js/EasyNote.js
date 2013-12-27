// Generated by CoffeeScript 1.6.3
(function() {
  var EasyNote;

  EasyNote = (function() {
    EasyNote.prototype.WIDTH = (window.innerWidth / 100) * 80;

    EasyNote.prototype.HEIGHT = null;

    EasyNote.prototype.LINE_SPACE = 20;

    EasyNote.prototype.background = null;

    EasyNote.prototype.canvas = null;

    function EasyNote() {
      this.HEIGHT = Math.floor(this.WIDTH * 1.29411764706);
      this.setupStage();
      this.setupBackground();
      this.setupCanvas();
    }

    EasyNote.prototype.setupStage = function() {
      return this.stage = new Kinetic.Stage({
        container: 'easynote',
        width: this.WIDTH,
        height: this.HEIGHT
      });
    };

    EasyNote.prototype.setupBackground = function() {
      this.background = new Kinetic.Layer();
      this.grid();
      return this.stage.add(this.background);
    };

    EasyNote.prototype.setupCanvas = function() {
      var cnv,
        _this = this;
      this.canvas = new Kinetic.Layer();
      window.canvas = this.canvas;
      this.stage.add(this.canvas);
      this.canvas.drawing = false;
      this.canvas.context = this.canvas.getCanvas()._canvas.getContext('2d');
      this.canvas.beginLine = function(x, y) {
        this.drawing = true;
        this.context.beginPath();
        this.context.strokeStyle = 'black';
        this.context.lineWidth = '5';
        return this.context.moveTo(x, y);
      };
      this.canvas.drawLine = function(x, y) {
        if (!this.drawing) {
          return;
        }
        this.context.lineTo(x, y);
        return this.context.stroke();
      };
      this.canvas.endLine = function() {
        return this.drawing = false;
      };
      cnv = this.canvas.getCanvas()._canvas;
      $(cnv).on('mousedown', function(event) {
        var offset;
        console.log('down');
        offset = $(event.currentTarget).offset();
        return _this.canvas.beginLine(event.clientX - offset.left, event.clientY - offset.top);
      });
      $(cnv).on('mousemove', function(event) {
        var offset;
        console.log('move');
        offset = $(event.currentTarget).offset();
        return _this.canvas.drawLine(event.clientX - offset.left, event.clientY - offset.top);
      });
      return $(cnv).on('mouseup', function() {
        console.log('up');
        return _this.canvas.endLine();
      });
    };

    EasyNote.prototype.makeRule = function(coord, horizontal) {
      points;
      var points;
      if (horizontal) {
        points = [0, coord, this.WIDTH, coord];
      } else {
        points = [coord, 0, coord, this.HEIGHT];
      }
      return new Kinetic.Line({
        points: points,
        stroke: 'blue',
        strokeWidth: 1
      });
    };

    EasyNote.prototype.grid = function() {
      this.background.clear();
      return this.makeRules('both');
    };

    EasyNote.prototype.makeRules = function(kind) {
      var line, lines, x, y, _i, _j, _k, _len, _ref, _ref1, _ref2, _ref3, _results;
      lines = [];
      if (kind === "horizontal" || kind === "both") {
        for (y = _i = 0, _ref = this.HEIGHT, _ref1 = this.LINE_SPACE; _ref1 > 0 ? _i <= _ref : _i >= _ref; y = _i += _ref1) {
          lines.push(this.makeRule(y, true));
        }
      }
      if (kind === "vertical" || kind === "both") {
        for (x = _j = 0, _ref2 = this.WIDTH, _ref3 = this.LINE_SPACE; _ref3 > 0 ? _j <= _ref2 : _j >= _ref2; x = _j += _ref3) {
          lines.push(this.makeRule(x, false));
        }
      }
      _results = [];
      for (_k = 0, _len = lines.length; _k < _len; _k++) {
        line = lines[_k];
        _results.push(this.background.add(line));
      }
      return _results;
    };

    EasyNote.prototype.redraw = function() {
      this.stage = null;
      this.setupStage();
      return this.stage.add(this.background);
    };

    return EasyNote;

  })();

  new EasyNote;

}).call(this);
