var Backstretch;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
Backstretch = (function() {
  function Backstretch(src, options) {
    this.src = src;
    this.settings = {
      centeredX: true,
      centeredY: true,
      speed: 1.0
    };
    if (options && typeof options === "object") {
      Object.extend(this.settings, options);
    }
    if (this.src) {
      this.container = new Element("div", {
        'id': 'backstretch'
      });
      this.container.setStyle({
        left: 0,
        top: 0,
        position: "fixed",
        overflow: "hidden",
        zIndex: -998
      });
      this.create_image();
      document.body.insert({
        top: this.container
      });
      this.img.src = this.src;
    }
    Event.observe(window, 'resize', __bind(function() {
      return this.adjust();
    }, this));
    this;
  }
  Backstretch.prototype.create_image = function() {
    this.img = new Element("img");
    this.img.setStyle({
      position: "relative",
      display: "none"
    });
    this.img.observe('load', __bind(function(event) {
      this.container.insert(this.img);
      this.ratio = this.img.width / this.img.height;
      if (Prototype.Browser.IE) {
        return this.img.appear({
          duration: this.settings.speed,
          after: __bind(function() {
            return this.adjust();
          }, this)
        });
      } else {
        return this.img.appear({
          duration: this.settings.speed,
          before: __bind(function() {
            return this.adjust();
          }, this)
        });
      }
    }, this));
    return this;
  };
  Backstretch.prototype.change_source = function(src) {
    if (src !== this.img.src) {
      this.img.fade({
        after: __bind(function() {
          this.img.remove();
          this.create_image();
          return this.img.src = src;
        }, this)
      });
    }
    return this;
  };
  Backstretch.prototype.adjust = function() {
    var bgCSS, bgHeight, bgOffset, bgWidth, _height, _width;
    _width = document.viewport.getWidth();
    _height = document.viewport.getHeight();
    bgCSS = {
      left: 0,
      top: 0
    };
    bgWidth = _width;
    bgHeight = bgWidth / this.ratio;
    if (bgHeight >= _height) {
      bgOffset = (bgHeight - _height) / 2;
      if (this.settings.centeredY) {
        Object.extend(bgCSS, {
          top: "-" + bgOffset + "px"
        });
      }
    } else {
      bgHeight = _height + 10;
      bgWidth = bgHeight * this.ratio;
      bgOffset = (bgWidth - _width) / 2;
      if (this.settings.centeredX) {
        Object.extend(bgCSS, {
          left: "-" + bgOffset + "px"
        });
      }
    }
    this.img.setStyle("width: " + bgWidth + "px; height:" + bgHeight + "px;").setStyle(bgCSS);
    return this;
  };
  return Backstretch;
})();