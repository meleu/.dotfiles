# useful prompt style for copy'n'paste
IRB.conf[:PROMPT][:COPYNPASTE] = {
  AUTO_INDENT: true,
  PROMPT_I: "> ",     # Normal prompt
  PROMPT_S: nil,      # in a string
  PROMPT_C: nil,      # in a block or other expression
  PROMPT_N: nil,      # in a nested expression
  RETURN: "# => %s\n" # How to display return values
}
IRB.conf[:PROMPT_MODE] = :COPYNPASTE
