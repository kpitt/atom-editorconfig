editorconfig = require('editorconfig')

init = (editor) ->
  file = editor.getURI()
  if !file
    return
  editorconfig.parse(file).then (config) ->
    if Object.keys(config).length == 0
      return
    isTab = config.indent_style == 'tab' or !editor.softTabs
    if isTab
      editor.setSoftTabs false
      if config.tab_width
        editor.setTabLength config.tab_width
    else
      editor.setSoftTabs true
      if config.indent_size
        editor.setTabLength config.indent_size
    if config.charset
      # EditorConfig charset names matches iconv charset names.
      # Which is used by Atom. So no charset name convertion is needed.
      editor.setEncoding config.charset
    return
  return

module.exports =
  activate: ->
    @initSubscription = atom.workspace.observeTextEditors init

  deactivate: ->
    @initSubscription.dispose()
