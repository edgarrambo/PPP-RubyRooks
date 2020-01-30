App.game = App.cable.subscriptions.create "GameChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    if data.piece
      $.ajax
        url: "/pieces/#{data.piece.id}/reload?game_id=#{data.piece.game_id}",
        type: 'GET'

    if data.path
      window.location.pathname = data.path;

    if data.game
      $.ajax
        url: "/games/#{data.game.id}/reload?game_id=#{data.game.id}",
        type: 'GET'
