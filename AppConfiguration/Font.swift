import UIKit

public final class Font {
    
    public enum Weight {
        case regular
        case medium
        case bold
        case italic
        case boldItalic
    }
    
    public static func main(ofSize size: CGFloat, weight: Weight) -> UIFont {
        switch weight {
        case .regular:
            return UIFont(name: "helveticaneuecyr-roman", size: size)!
        case .medium:
            return UIFont(name: "helveticaneuecyr-medium", size: size)!
        case .bold:
            return UIFont(name: "helveticaneuecyr-bold", size: size)!
        case .italic:
            return UIFont(name: "helveticaneuecyr-italic", size: size)!
        case .boldItalic:
            return UIFont(name: "helveticaneuecyr-bolditalic", size: size)!
        }
    }
    
}
