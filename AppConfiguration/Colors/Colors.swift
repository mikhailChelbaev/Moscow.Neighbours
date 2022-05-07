import UIKit

public final class Color {
    private class CurrentBundleClass {}
    
    private static var currentBundle: Bundle {
        Bundle(for: CurrentBundleClass.self)
    }
    
    public static var background: UIColor = UIColor(named: "background", in: currentBundle, compatibleWith: nil)!
}
