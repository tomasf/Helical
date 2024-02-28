import Foundation
import SwiftSCAD

protocol Nut: Shape3D {
    typealias Standard = StandardNut

    @UnionBuilder3D func makeNutTrap(depthClearance: Double) -> any Geometry3D
}

extension Nut {
    func makeNutTrap() -> any Geometry3D {
        makeNutTrap(depthClearance: 0)
    }
}

struct StandardNut {}
