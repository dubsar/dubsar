$ ->
  $.fn.jQCloud = (word_array, options) ->
    $this = this
    cloud_namespace = $this.attr("id") or Math.floor((Math.random() * 1000000)).toString(36)
    default_options =
      width: $this.width()
      height: $this.height()
      center:
        x: $this.width() / 2.0
        y: $this.height() / 2.0

      delayedMode: word_array.length > 50
      randomClasses: 0
      nofollow: false
      shape: false

    options = callback: options  if typeof options is "function"
    options = $.extend(default_options, options or {})
    $this.addClass "jqcloud"
    drawWordCloud = ->
      hitTest = (elem, other_elems) ->
        overlapping = (a, b) ->
          return unless a and b
          return true  if Math.abs(2.0 * a.offsetTop + a.offsetHeight - 2.0 * b.offsetTop - b.offsetHeight) < a.offsetHeight + b.offsetHeight  if Math.abs(2.0 * a.offsetLeft + a.offsetWidth - 2.0 * b.offsetLeft - b.offsetWidth) < a.offsetWidth + b.offsetWidth
          false

        i = 0
        i = 0
        while i < other_elems.length
          return true  if overlapping(elem, other_elems[i])
          i++
        false

      i = 0

      while i < word_array.length
        word_array[i].weight = parseFloat(word_array[i].weight, 10)
        i++
      word_array.sort (a, b) ->
        if a.weight < b.weight
          1
        else if a.weight > b.weight
          -1
        else
          0

      step = (if (options.shape is "rectangular") then 18.0 else 2.0)
      already_placed_words = []
      aspect_ratio = options.width / options.height
      drawOneWord = (index, word) ->
        word_id = cloud_namespace + "_word_" + index
        word_selector = "#" + word_id
        random_class = (if (typeof options.randomClasses is "number" and options.randomClasses > 0) then " r" + Math.ceil(Math.random() * options.randomClasses) else (if ($.isArray(options.randomClasses) and options.randomClasses.length > 0) then " " + options.randomClasses[Math.floor(Math.random() * options.randomClasses.length)] else ""))
        angle = 6.28 * Math.random()
        radius = 0.0
        steps_in_direction = 0.0
        quarter_turns = 0.0
        weight = 5
        inner_html = undefined
        word_span = undefined
        weight = Math.round((word.weight - word_array[word_array.length - 1].weight) / (word_array[0].weight - word_array[word_array.length - 1].weight) * 9.0) + 1  if word_array[0].weight > word_array[word_array.length - 1].weight
        word_span = $("<span>").attr("id", word_id).attr("class", "w" + weight).addClass(random_class).addClass(word.customClass or null).attr("title", word.title or word.text or "")
        if word.dataAttributes
          $.each word.dataAttributes, (i, v) ->
            word_span.attr "data-" + i, v
        unless not word.url
          inner_html = $("<a>").attr("href", encodeURI(word.url).replace(/'/g, "%27")).text(word.text)
          inner_html.attr "rel", "nofollow"  unless not options.nofollow
        else
          inner_html = word.text
        word_span.append inner_html
        unless not word.handlers
          for prop of word.handlers
            $(word_span).bind prop, word.handlers[prop]  if word.handlers.hasOwnProperty(prop) and typeof word.handlers[prop] is "function"
        $this.append word_span
        width = word_span.width()
        height = word_span.height()
        left = options.center.x - width / 2.0
        top = options.center.y - height / 2.0
        word_style = word_span[0].style
        word_style.position = "absolute"
        word_style.left = left + "px"
        word_style.top = top + "px"
        while hitTest(document.getElementById(word_id), already_placed_words)
          if options.shape is "rectangular"
            steps_in_direction++
            if steps_in_direction * step > (1 + Math.floor(quarter_turns / 2.0)) * step * (if (quarter_turns % 4 % 2) is 0 then 1 else aspect_ratio)
              steps_in_direction = 0.0
              quarter_turns++
            switch quarter_turns % 4
              when 1
                left += step * aspect_ratio + Math.random() * 2.0
              when 2
                top -= step + Math.random() * 2.0
              when 3
                left -= step * aspect_ratio + Math.random() * 2.0
              when 0
                top += step + Math.random() * 2.0
          else
            radius += step
            angle += (if index % 2 is 0 then 1 else -1) * step
            left = options.center.x - (width / 2.0) + (radius * Math.cos(angle)) * aspect_ratio
            top = options.center.y + radius * Math.sin(angle) - (height / 2.0)
          word_style.left = left + "px"
          word_style.top = top + "px"
        already_placed_words.push document.getElementById(word_id)
        word.callback.call word_span  if typeof word.callback is "function"

      drawOneWordDelayed = (index) ->
        index = index or 0
        if index < word_array.length
          drawOneWord index, word_array[index]
          setTimeout (->
            drawOneWordDelayed index + 1
          ), 10
        else
          options.callback.call this  if typeof options.callback is "function"

      if options.delayedMode or options.delayed_mode
        drawOneWordDelayed()
      else
        $.each word_array, drawOneWord
        options.callback.call this  if typeof options.callback is "function"

    setTimeout (->
      drawWordCloud()
    ), 10
