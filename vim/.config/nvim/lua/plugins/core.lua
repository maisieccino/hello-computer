return {
  {
    "LazyVim/LazyVim",
    opts = {
      ---@type table<string, string[]|boolean>?
      kind_filter = {
        -- Include variables and constants in symbol list.
        go = {
          "Class",
          "Constructor",
          "Constant",
          "Enum",
          "Field",
          "Function",
          "Interface",
          "Method",
          "Module",
          "Namespace",
          "Package",
          "Property",
          "Struct",
          "Trait",
          "Variable",
        },
      },
    },
  },
}
