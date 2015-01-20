App.factory 'notification', ->
  {
    info: (msg)->
      if window.plugins?.toast
        window.plugins.toast.showShortBottom(msg)
      else
        console.log(msg)
  }
