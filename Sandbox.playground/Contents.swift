import UIKit

var greeting = "Hello, playground"


let text = "\\"
let specialCharacterRegex = "[@:?!()$#,./\\\\]+"
// just to put \  (one backslash)
// we need to put \\\\ (four backslash)
text.range(of: specialCharacterRegex, options: .regularExpression) != nil
