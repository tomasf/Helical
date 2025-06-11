import Foundation
import Cadova

public protocol BoltPoint: Shape3D {
    var boltLength: Double { get }
    var negativeBody: any Geometry3D { get }
}

public extension BoltPoint {
    var body: any Geometry3D { Box(.zero) }
    @GeometryBuilder3D var negativeBody: any Geometry3D { Box(.zero) }
}
