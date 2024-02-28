import Foundation
import SwiftSCAD

protocol BoltHeadShape: Shape3D {
    var height: Double { get }
    var boltLength: Double { get }
    var clearanceLength: Double { get }
    var recess: any BoltHeadRecess { get }
}

extension BoltHeadShape {
    var boltLength: Double { 0 }
    var clearanceLength: Double { height }
}
