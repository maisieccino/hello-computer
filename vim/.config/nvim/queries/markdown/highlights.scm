;; extends
((inline) @_inline (#lua-match? @_inline "^%s*import")) @nospell
((inline) @_inline (#lua-match? @_inline "^%s*export")) @nospell

; Hightlight TK comments in markdown files.
(
  (inline) @tk
  (#match? @tk "^TK:")
  (#gsub! @tk "^TK: " "")
) @comment.note
