import Foundation
import Cadova

public protocol BoltPoint: Shape3D {
    var consumedLength: Double { get }
    @GeometryBuilder3D var negativeBody: any Geometry3D { get }
}

public extension BoltPoint {
    @GeometryBuilder3D var body: any Geometry3D {}
    @GeometryBuilder3D var negativeBody: any Geometry3D { }
}
