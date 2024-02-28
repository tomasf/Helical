import Foundation
import SwiftSCAD

public protocol Nut: Shape3D {
    typealias Standard = StandardNut

    @UnionBuilder3D func makeNutTrap(depthClearance: Double) -> any Geometry3D
}

public extension Nut {
    func makeNutTrap() -> any Geometry3D {
        makeNutTrap(depthClearance: 0)
    }
}

public struct StandardNut {}
