editorconfig = require('editorconfig')

init = (editor) ->
  file = editor.getURI()
  return unless file

  editorconfig.parse(file).then (config) ->
    return if Object.keys(config).length == 0

    isTab = config.indent_style == 'tab' or !editor.softTabs
    if isTab
      editor.setSoftTabs false
      editor.setTabLength config.tab_width if config.tab_width
    else
      editor.setSoftTabs true
      editor.setTabLength config.indent_size if config.indent_size

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
