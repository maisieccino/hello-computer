;; extends

; Adds promql code injection to yaml definitions.
((block_mapping_pair
   key: (flow_node
      (plain_scalar (string_scalar) @key)
      (#eq? @key "expr")
   )
   value: (flow_node
      (plain_scalar (string_scalar) @promql_expr)
      (#set! injection.language "promql")
   )
))
