import Foundation
import SwiftSCAD

public extension ScrewThread {
    static var m1   = isoMetric(.m1)
    static var m1p2 = isoMetric(.m1p2)
    static var m1p4 = isoMetric(.m1p4)
    static var m1p6 = isoMetric(.m1p6)
    static var m1p8 = isoMetric(.m1p8)
    static var m2   = isoMetric(.m2)
    static var m2p5 = isoMetric(.m2p5)
    static var m3   = isoMetric(.m3)
    static var m3p5 = isoMetric(.m3p5)
    static var m4   = isoMetric(.m4)
    static var m5   = isoMetric(.m5)
    static var m6   = isoMetric(.m6)
    static var m7   = isoMetric(.m7)
    static var m8   = isoMetric(.m8)
    static var m10  = isoMetric(.m10)
    static var m12  = isoMetric(.m12)
    static var m14  = isoMetric(.m14)
    static var m16  = isoMetric(.m16)
    static var m18  = isoMetric(.m18)
    static var m20  = isoMetric(.m20)
    static var m22  = isoMetric(.m22)
    static var m24  = isoMetric(.m24)
    static var m27  = isoMetric(.m27)
    static var m30  = isoMetric(.m30)
    static var m33  = isoMetric(.m33)
    static var m36  = isoMetric(.m36)
    static var m39  = isoMetric(.m39)
    static var m42  = isoMetric(.m42)
    static var m45  = isoMetric(.m45)
    static var m48  = isoMetric(.m48)
    static var m52  = isoMetric(.m52)
    static var m56  = isoMetric(.m56)
    static var m60  = isoMetric(.m60)
    static var m64  = isoMetric(.m64)
}

public extension ScrewThread {
    static func isoMetric(_ size: ISOMetricSize, pitch: Double? = nil) -> ScrewThread {
        let coarsePitch: Double
        switch size {
        case .m1:   coarsePitch = 0.25
        case .m1p2: coarsePitch = 0.25
        case .m1p4: coarsePitch = 0.30
        case .m1p6: coarsePitch = 0.35
        case .m1p8: coarsePitch = 0.35
        case .m2:   coarsePitch = 0.40
        case .m2p5: coarsePitch = 0.45
        case .m3:   coarsePitch = 0.50
        case .m3p5: coarsePitch = 0.60
        case .m4:   coarsePitch = 0.70
        case .m5:   coarsePitch = 0.80
        case .m6:   coarsePitch = 1.00
        case .m7:   coarsePitch = 1.00
        case .m8:   coarsePitch = 1.25
        case .m10:  coarsePitch = 1.50
        case .m12:  coarsePitch = 1.75
        case .m14:  coarsePitch = 2.00
        case .m16:  coarsePitch = 2.00
        case .m18:  coarsePitch = 2.50
        case .m20:  coarsePitch = 2.50
        case .m22:  coarsePitch = 2.50
        case .m24:  coarsePitch = 3.00
        case .m27:  coarsePitch = 3.00
        case .m30:  coarsePitch = 3.50
        case .m33:  coarsePitch = 3.50
        case .m36:  coarsePitch = 4.00
        case .m39:  coarsePitch = 4.00
        case .m42:  coarsePitch = 4.50
        case .m45:  coarsePitch = 4.50
        case .m48:  coarsePitch = 5.00
        case .m52:  coarsePitch = 5.00
        case .m56:  coarsePitch = 5.50
        case .m60:  coarsePitch = 5.50
        case .m64:  coarsePitch = 6.00
        }

        return .vShapedStandard(majorDiameter: size.rawValue, pitch: pitch ?? coarsePitch)
    }

    enum ISOMetricSize: Double {
        case m1   = 1
        case m1p2 = 1.2
        case m1p4 = 1.4
        case m1p6 = 1.6
        case m1p8 = 1.8
        case m2   = 2
        case m2p5 = 2.5
        case m3   = 3
        case m3p5 = 3.5
        case m4   = 4
        case m5   = 5
        case m6   = 6
        case m7   = 7
        case m8   = 8
        case m10  = 10
        case m12  = 12
        case m14  = 14
        case m16  = 16
        case m18  = 18
        case m20  = 20
        case m22  = 22
        case m24  = 24
        case m27  = 27
        case m30  = 30
        case m33  = 33
        case m36  = 36
        case m39  = 39
        case m42  = 42
        case m45  = 45
        case m48  = 48
        case m52  = 52
        case m56  = 56
        case m60  = 60
        case m64  = 64
    }
}
