syntax match dirName "\v[^(\t*(\+|\-))].*/"
highlight link dirName Comment

syntax match dirSymbol "\v\+|\-"
highlight link dirSymbol Include
