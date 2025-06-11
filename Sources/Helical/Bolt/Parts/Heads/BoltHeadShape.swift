import Foundation
import Cadova

public protocol BoltHeadShape: Shape3D {
    var height: Double { get }
    var boltLength: Double { get }
    var clearanceLength: Double { get }
    var recess: (any Geometry3D)? { get }
    var negativeBody: any Geometry3D { get}
}

public extension BoltHeadShape {
    var boltLength: Double { 0 }
    var clearanceLength: Double { height }
    var negativeBody: any Geometry3D { Box(.zero) }
}
