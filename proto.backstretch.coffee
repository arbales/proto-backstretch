#
# Proto Backstretch
# Version 1.0
#
# A port of jQuery Backstretch
# http://srobbin.com/jquery-plugins/jquery-backstretch/
#
# Add a dynamically-resized background image to the page
#         
# Copyright (c) 2010 Scott Robbin (srobbin.com), Austin Bales (austinbales.com)
# Dual licensed under the MIT and GPL licenses.
#


class Backstretch
  constructor: (@src, options) ->
    
    @settings = {
      centeredX: true    #  Should we center the image on the X axis?
      centeredY: true    #  Should we center the image on the Y axis?
      speed: 1.0         #  fadeIn speed for background after image loads (e.g. "fast" or 500)
    }                
    
    ## Extend the settings with those the user has provided      
    if options and typeof options is "object"   
      Object.extend(@settings, options)
    
    if @src              
      # Prepend image, wrapped in a DIV, with some positioning and zIndex voodoo      
      @container = new Element "div", {'id': 'backstretch'}
      @container.setStyle({left: 0, top: 0, position: "fixed", overflow: "hidden", zIndex: -998})
      @create_image()
      document.body.insert({top: @container})
      @img.src = @src  

    this # for chaining

  create_image: ->
    @img = new Element("img")
    @img.setStyle {position: "relative", display: "none"}
    @img.observe('load', (event) =>
      
      @container.insert @img
      @ratio = @img.width / @img.height 
      
      # Internet Explorer doesn't seem to be able to detect proper width until after the element
      # is set with display:block`d. The jQuery solution for this is different.
      if Prototype.Browser.IE
        @img.appear({duration:@settings.speed, after: => @adjust()})
      else
        @img.appear({duration:@settings.speed, before: => @adjust()})
    )
    this
    
  change_source: (src) ->
    # If the source is the same, don't bother. 
    if src != @img.src
      @img.fade({after: =>
        @img.remove() # Removing and re-adding the element prevents a racy flicker in IE.
        @create_image()
        @img.src = src
      })
    this  
  
  adjust: ->
    _width = document.viewport.getWidth()
    _height = document.viewport.getHeight()

    bgCSS = {left:0, top:0}
    bgWidth = _width
    bgHeight = bgWidth / @ratio
    
    # Make adjustments based on image ratio
    # Note: Offset code provided by Peter Baker (http://ptrbkr.com/). Thanks, Peter!
    if bgHeight >= _height
      bgOffset = (bgHeight - _height) / 2
      if @settings.centeredY
        Object.extend(bgCSS, {top: "-#{bgOffset}px"})
    else
      bgHeight = _height + 10
      bgWidth = bgHeight * @ratio
      bgOffset = (bgWidth - _width) / 2
      if @settings.centeredX
        Object.extend(bgCSS, {left: "-#{bgOffset}px"})
    @img.setStyle("width: #{bgWidth}px; height:#{bgHeight}px;").setStyle(bgCSS)
    this
    
