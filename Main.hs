import Lexer
import Parser
import Interp
import State

main = do
  source <- getContents
  let tokens = alexScanTokens source
  let ast = parser tokens
  case interp ast of
    S s -> print $ State.toList s
    Bottom -> print "notdef"