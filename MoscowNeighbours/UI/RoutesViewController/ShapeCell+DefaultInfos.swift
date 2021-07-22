import UIKit

extension ShapeCell {
    static func makeDefaultInfos() -> [ShapeCell.Info] {
        return [
            ShapeCell.Info(
                title: "Circle",
                subtitle: "A circle is a simple closed shape. It is the set of all points in a plane that are at a given distance from a given point, the centre; equivalently it is the curve traced out by a point that moves so that its distance from a given point is constant.",
                shape: UIBezierPath(ovalIn: shapeRect)
            ),
            
            ShapeCell.Info(
                title: "Triangle",
                subtitle: "A triangle is a polygon with three edges and three vertices. It is one of the basic shapes in geometry.",
                shape: makePolygon(sides: 3)
            ),
            
            ShapeCell.Info(
                title: "Square",
                subtitle: "In geometry, a square is a regular quadrilateral, which means that it has four equal sides and four equal angles (90-degree angles, or (100-gradian angles or right angles).",
                shape: UIBezierPath(rect: shapeRect)
            ),
            
            ShapeCell.Info(
                title: "Rectangle",
                subtitle: "In Euclidean plane geometry, a rectangle is a quadrilateral with four right angles. It can also be defined as an equiangular quadrilateral, since equiangular means that all of its angles are equal (360°/4 = 90°).",
                shape: UIBezierPath(rect: CGRect(x: 0, y: 0, width: shapeSize.width, height: shapeSize.height - 8))
            ),
            
            ShapeCell.Info(
                title: "Squircle",
                subtitle: "A squircle is a mathematical shape intermediate between a square and a circle. It is a special case of a superellipse. The word \"squircle\" is a portmanteau of the words \"square\" and \"circle\".",
                shape: UIBezierPath(roundedRect: shapeRect, cornerRadius: 8)
            ),
            
            ShapeCell.Info(
                title: "Pentagon",
                subtitle: "In geometry, a pentagon (from the Greek πέντε pente and γωνία gonia, meaning five and angle) is any five-sided polygon or 5-gon. The sum of the internal angles in a simple pentagon is 540°.",
                shape: makePolygon(sides: 5)
            ),
            
            ShapeCell.Info(
                title: "Octagon",
                subtitle: "In geometry, an octagon (from the Greek ὀκτάγωνον oktágōnon, \"eight angles\") is an eight-sided polygon or 8-gon.",
                shape: makePolygon(sides: 8)
            ),
        ]
    }

    private static let shapeSize = CGSize(width: ShapeCell.Layout.shapeSize, height: ShapeCell.Layout.shapeSize)

    private static let shapeRect = CGRect(origin: .zero, size: shapeSize)

    private static let shapeCenter = CGPoint(x: shapeRect.midX, y: shapeRect.midY)

    private static let shapeRadius = shapeSize.width / 2

    private static func makePolygon(
        sides: Int,
        center: CGPoint = shapeCenter,
        radius: CGFloat = shapeRadius,
        offset: CGFloat = 0
    ) -> UIBezierPath {
        return UIBezierPath(polygonSides: sides, center: center, radius: radius, offset: offset)
    }
}


extension UIBezierPath {

    convenience init(polygonSides sides: Int, center: CGPoint, radius: CGFloat, offset: CGFloat = 0) {
        self.init()
        
        let points = UIBezierPath.polygonPoints(sides: sides, center: center, radius: radius, offset: offset)
        
        if points.count > 1 {
            move(to: points.first!)
            
            for i in 1 ..< points.count {
                addLine(to: points[i])
            }
            
            close()
        }
    }

    static func polygonPoints(sides: Int, center: CGPoint, radius: CGFloat, offset: CGFloat = 0)
        -> [CGPoint]
    {
        func toRadians(_ value: CGFloat) -> CGFloat {
            return value / 180 * .pi
        }
    
        let angle = toRadians(360 / CGFloat(sides))
        let cx = center.x
        let cy = center.y
        let r = radius
        let o = toRadians(offset)
        
        return (0 ..< sides).map { i in
            let xpo = cx + r * sin(angle * CGFloat(i) - o)
            let ypo = cy - r * cos(angle * CGFloat(i) - o)
            return CGPoint(x: xpo, y: ypo)
        }
    }
}
