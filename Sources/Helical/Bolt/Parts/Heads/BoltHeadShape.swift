import Foundation
import Cadova

public protocol BoltHeadShape: Shape3D {
    var height: Double { get }
    var consumedLength: Double { get }
    var clearanceLength: Double { get }
    @GeometryBuilder3D var recess: any Geometry3D { get }
    @GeometryBuilder3D var negativeBody: any Geometry3D { get }
}

public extension BoltHeadShape {
    var consumedLength: Double { 0 }
    var clearanceLength: Double { height }
    var negativeBody: any Geometry3D { Box(.zero) }
}
