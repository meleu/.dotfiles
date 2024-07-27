# minify
jq --compact-output input.json

# "if" with no "else"
jq 'if CONDITION then SOMETHING else empty end' input.json

# return empty string if result is `null`
# -> use '// empty' at the end of the expression
jq '.EXPRESSION // empty' input.json

# To access first list item:
jq '.[0]'

# to slice and dice:
jq '.[2:4]'
jq '.[:3]'
jq '.[-2:]'
