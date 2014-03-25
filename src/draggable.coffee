React = require 'react'
$ = require 'jquery'

Draggable = ({useX, useY, minX, maxX}) ->
    componentDidUpdate: (props, state) ->
        if @state.dragging and not state.dragging
            document.addEventListener 'mousemove', @onMouseMove
            document.addEventListener 'mouseup', @onMouseUp
        else unless @state.dragging and state.dragging
            document.removeEventListener 'mousemove', @onMouseMove
            document.removeEventListener 'mouseup', @onMouseUp

    onMouseDown: (e) ->
        return if e.button isnt 0
        width = $(@getDOMNode()).width()

        rel = {}
        newX = e.pageX
        {minX, maxX} = @props

        rel.x = if newX >= minX and newX <= maxX
            e.pageX
        else if newX <= minX
            minX
        else if newX >= maxX
            maxX - (2*width)

        @setState {dragging: true, rel}
        e.stopPropagation()
        e.preventDefault()

    onMouseUp: (e) ->
        @setState {dragging: false}
        e.stopPropagation()
        e.preventDefault()

    onMouseMove: (e) ->
        return unless @state.dragging

        pos = {}
        newX = e.pageX - @state.rel.x
        {minX, maxX} = @props

        pos.x = if newX >= minX and newX <= maxX
            newX
        else if newX <= minX
            minX
        else if newX >= maxX
            maxX

        @props.onXChange?(pos.x)

        @setState {pos}
        e.stopPropagation()
        e.preventDefault()

module.exports = Draggable
