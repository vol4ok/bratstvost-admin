filterText = (str) ->
  return str
    .replace(/[ ]{2,}/, " ")
    .replace(/ПНИ/g, "<abbr title=\"Психоневрологический интернат\">ПНИ</abbr>")

REXP_STRIP_P = /^<p>(.*)<\/p>\s*$/
stripP = (str) -> 
  if REXP_STRIP_P.test(str) then RegExp.$1 else str

FSM = (str) ->
  filterText(stripP(marked(str))).trim()

angular.module('appLibs').factory "textHelpers", ->
  return {
    filterText
    stripP
    FSM
  }