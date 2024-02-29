import Foundation
import SwiftSCAD

public extension ScrewThread {
    /// Standard M1x0.25 ISO metric coarse thread
    static var m1   = isoMetric(.m1)
    /// Standard M1.2x0.25 ISO metric coarse thread
    static var m1p2 = isoMetric(.m1p2)
    /// Standard M1.4x0.3 ISO metric coarse thread
    static var m1p4 = isoMetric(.m1p4)
    /// Standard M1.6x0.35 ISO metric coarse thread
    static var m1p6 = isoMetric(.m1p6)
    /// Standard M1.8x0.35 ISO metric coarse thread
    static var m1p8 = isoMetric(.m1p8)
    /// Standard M2x0.4 ISO metric coarse thread
    static var m2   = isoMetric(.m2)
    /// Standard M2.5x0.45 ISO metric coarse thread
    static var m2p5 = isoMetric(.m2p5)
    /// Standard M3x0.5 ISO metric coarse thread
    static var m3   = isoMetric(.m3)
    /// Standard M3.5x0.6 ISO metric coarse thread
    static var m3p5 = isoMetric(.m3p5)
    /// Standard M4x0.7 ISO metric coarse thread
    static var m4   = isoMetric(.m4)
    /// Standard M5x0.8 ISO metric coarse thread
    static var m5   = isoMetric(.m5)
    /// Standard M6x1.0 ISO metric coarse thread
    static var m6   = isoMetric(.m6)
    /// Standard M7x1.0 ISO metric coarse thread
    static var m7   = isoMetric(.m7)
    /// Standard M8x1.25 ISO metric coarse thread
    static var m8   = isoMetric(.m8)
    /// Standard M10x1.5 ISO metric coarse thread
    static var m10  = isoMetric(.m10)
    /// Standard M12x1.75 ISO metric coarse thread
    static var m12  = isoMetric(.m12)
    /// Standard M14x2.0 ISO metric coarse thread
    static var m14  = isoMetric(.m14)
    /// Standard M16x2.0 ISO metric coarse thread
    static var m16  = isoMetric(.m16)
    /// Standard M18x2.5 ISO metric coarse thread
    static var m18  = isoMetric(.m18)
    /// Standard M20x2.5 ISO metric coarse thread
    static var m20  = isoMetric(.m20)
    /// Standard M22x2.5 ISO metric coarse thread
    static var m22  = isoMetric(.m22)
    /// Standard M24x3.0 ISO metric coarse thread
    static var m24  = isoMetric(.m24)
    /// Standard M27x3.0 ISO metric coarse thread
    static var m27  = isoMetric(.m27)
    /// Standard M30x3.5 ISO metric coarse thread
    static var m30  = isoMetric(.m30)
    /// Standard M33x3.5 ISO metric coarse thread
    static var m33  = isoMetric(.m33)
    /// Standard M36x4.0 ISO metric coarse thread
    static var m36  = isoMetric(.m36)
    /// Standard M39x4.0 ISO metric coarse thread
    static var m39  = isoMetric(.m39)
    /// Standard M42x4.5 ISO metric coarse thread
    static var m42  = isoMetric(.m42)
    /// Standard M45x4.5 ISO metric coarse thread
    static var m45  = isoMetric(.m45)
    /// Standard M48x5.0 ISO metric coarse thread
    static var m48  = isoMetric(.m48)
    /// Standard M52x5.0 ISO metric coarse thread
    static var m52  = isoMetric(.m52)
    /// Standard M56x5.5 ISO metric coarse thread
    static var m56  = isoMetric(.m56)
    /// Standard M60x5.5 ISO metric coarse thread
    static var m60  = isoMetric(.m60)
    /// Standard M64x6.0 ISO metric coarse thread
    static var m64  = isoMetric(.m64)
}

public extension ScrewThread {
    static func isoMetric(_ size: ISOMetricSize, pitch: Double? = nil) -> ScrewThread {
        let coarsePitch = switch size {
        case .m1:   0.25
        case .m1p2: 0.25
        case .m1p4: 0.30
        case .m1p6: 0.35
        case .m1p8: 0.35
        case .m2:   0.40
        case .m2p5: 0.45
        case .m3:   0.50
        case .m3p5: 0.60
        case .m4:   0.70
        case .m5:   0.80
        case .m6:   1.00
        case .m7:   1.00
        case .m8:   1.25
        case .m10:  1.50
        case .m12:  1.75
        case .m14:  2.00
        case .m16:  2.00
        case .m18:  2.50
        case .m20:  2.50
        case .m22:  2.50
        case .m24:  3.00
        case .m27:  3.00
        case .m30:  3.50
        case .m33:  3.50
        case .m36:  4.00
        case .m39:  4.00
        case .m42:  4.50
        case .m45:  4.50
        case .m48:  5.00
        case .m52:  5.00
        case .m56:  5.50
        case .m60:  5.50
        case .m64:  6.00
        }

        return .vShapedStandard(majorDiameter: size.rawValue, pitch: pitch ?? coarsePitch)
    }

    // Standard metric screw sizes according to ISO 262
    enum ISOMetricSize: Double {
        /// M1
        case m1   = 1
        /// M1.2
        case m1p2 = 1.2
        /// M1.4
        case m1p4 = 1.4
        /// M1.6
        case m1p6 = 1.6
        /// M1.8
        case m1p8 = 1.8
        /// M2
        case m2   = 2
        /// M2.5
        case m2p5 = 2.5
        /// M3
        case m3   = 3
        /// M3.5
        case m3p5 = 3.5
        /// M4
        case m4   = 4
        /// M5
        case m5   = 5
        /// M6
        case m6   = 6
        /// M7
        case m7   = 7
        /// M8
        case m8   = 8
        /// M10
        case m10  = 10
        /// M12
        case m12  = 12
        /// M14
        case m14  = 14
        /// M16
        case m16  = 16
        /// M18
        case m18  = 18
        /// M20
        case m20  = 20
        /// M22
        case m22  = 22
        /// M24
        case m24  = 24
        /// M27
        case m27  = 27
        /// M30
        case m30  = 30
        /// M33
        case m33  = 33
        /// M36
        case m36  = 36
        /// M39
        case m39  = 39
        /// M42
        case m42  = 42
        /// M45
        case m45  = 45
        /// M48
        case m48  = 48
        /// M52
        case m52  = 52
        /// M56
        case m56  = 56
        /// M60
        case m60  = 60
        /// M64
        case m64  = 64
    }
}
