; For MDX files. Allows for inline typescript
((inline) @injection.content
  (#lua-match? @injection.content "^%s*import")
  (#set! injection.language "tsx"))
((inline) @injection.content
  (#lua-match? @injection.content "^%s*export")
  (#set! injection.language "tsx"))
((inline) @injection.content
  (#lua-match? @injection.content "^<")
  (#set! injection.language "tsx"))

; For jupytext notebooks.
; Ensures magic strings are injected with their language.
(fenced_code_block
  (info_string
    ; (language) @lang
    ; (#match? @lang "python")
    (language) @injection.language
    (#match? @injection.language "python")
  )
  (code_fence_content) @injection.content ;@injection.language
  ; (code_fence_content) @injection.content @injection.language
  ; Match a magic directive.
  ; e.g. %%sql
  ; or escaped with a comment - # %%shell
  ; (#lua-match? @injection.language "^#?%s*%%%%(%a+).*\n")
  ; Start content at line after comment
  ; (#offset! @injection.content 1 0 0 0)
  ; (#gsub! @injection.language "^#?%s*%%%%(%a+).*$" "%1")
  ; If %%bigquery magic, hardcode to sql
  ; (#gsub! @injection.language "bigquery" "sql")
)

; Other python code blocks that don't contain
; magics
(fenced_code_block
  (info_string
    (language) @injection.language
  )
  (code_fence_content) @injection.content
  (#eq? @injection.language "python")
  (#not-lua-match? @injection.content "^#?%s*%%%%(%a+).*\n")
)
; Other non-python code blocks
(fenced_code_block
  (info_string
    (language) @injection.language
  )
  (code_fence_content) @injection.content
  (#not-eq? @injection.language "python")
)

((html_block) @injection.content
  (#set! injection.language "html"))

; Frontmatter
(document
  .
  (section
    .
    (thematic_break)
    (_) @injection.content
    (thematic_break))
  (#set! injection.language "yaml"))

((minus_metadata) @injection.content
  (#set! injection.language "yaml"))

((plus_metadata) @injection.content
  (#set! injection.language "toml"))

((inline) @injection.content
  (#set! injection.language "markdown_inline"))
