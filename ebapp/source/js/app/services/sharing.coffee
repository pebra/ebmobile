App.factory 'sharing', ->
  {
    # message = {
    #   subject: "Test Subject",
    #   text: "This is a test message",
    #   url: "http://ilee.co.uk"
    # }
    share: (message)->
      window.socialmessage.send(message)

    shareUrl: (url, title)->
      message = {
        subject: title
        url: url
      }
      window.socialmessage.send(message)
  }
