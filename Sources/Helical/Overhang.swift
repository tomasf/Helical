import SwiftSCAD

public enum TeardropOverhang {
    case bridged (Angle)
    case extended (Angle)

    public static let bridged = Self.bridged(45°)
    public static let extended = Self.extended(45°)
}

internal extension TeardropOverhang {
    var style: Teardrop.Style {
        switch self {
        case .bridged:
            return .bridged
        case .extended:
            return .full
        }
    }

    var angle: Angle {
        switch self {
        case .bridged (let angle): return angle
        case .extended (let angle): return angle
        }
    }

    func shape(diameter: Double) -> any Geometry2D {
        Teardrop(diameter: diameter, angle: angle, style: style)
    }
}

public extension Environment {
    private static let key = ValueKey(rawValue: "Helical.TeardropOverhang")

    var teardropOverhang: TeardropOverhang? {
        self[Self.key] as? TeardropOverhang
    }

    func withTeardropOverhang(_ overhang: TeardropOverhang?) -> Environment {
        setting(key: Self.key, value: overhang)
    }
}

public extension Geometry3D {
    func withTeardropOverhang(_ overhang: TeardropOverhang?) -> any Geometry3D {
        withEnvironment { e in
            e.withTeardropOverhang(overhang)
        }
    }

    func withoutTeardropOverhang() -> any Geometry3D {
        withEnvironment { e in
            e.withTeardropOverhang(nil)
        }
    }
}

internal struct OverhangCylinder: Shape3D {
    let bottomDiameter: Double
    let topDiameter: Double
    let height: Double

    init(diameter: Double, height: Double) {
        self.bottomDiameter = diameter
        self.topDiameter = diameter
        self.height = height
    }

    init(bottomDiameter: Double, topDiameter: Double, height: Double) {
        self.bottomDiameter = bottomDiameter
        self.topDiameter = topDiameter
        self.height = height
    }

    var body: any Geometry3D {
        EnvironmentReader { e in
            if let overhang = e.teardropOverhang {
                overhang.shape(diameter: bottomDiameter)
                    .extrudedHull(height: height, to: overhang.shape(diameter: topDiameter))
            } else {
                Cylinder(bottomDiameter: bottomDiameter, topDiameter: topDiameter, height: height)
            }
        }
    }
}

