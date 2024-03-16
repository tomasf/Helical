import Foundation
import SwiftSCAD

public protocol BoltHeadShape: Shape3D {
    var height: Double { get }
    var boltLength: Double { get }
    var clearanceLength: Double { get }
    var recess: (any BoltHeadRecess)? { get }
    var negativeBody: any Geometry3D { get}
}

public extension BoltHeadShape {
    var boltLength: Double { 0 }
    var clearanceLength: Double { height }
    var negativeBody: any Geometry3D { Box(.zero) }
}
