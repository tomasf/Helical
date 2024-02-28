import Foundation
import SwiftSCAD

// DIN 934 / ISO 4032
// Metric hex nuts
// https://www.fasteners.eu/standards/DIN/934/

extension StandardNut {
    static func hex(_ size: ScrewThread.ISOMetricSize) -> PolygonalNut {
        let headWidth: Double // s, width across flats
        let headHeight: Double // m

        (headWidth, headHeight) = switch size {
        case .m2:   (4,   1.6)
        case .m2p5: (5,   2)
        case .m3:   (5.5, 2.4)
        case .m3p5: (6,   2.8)
        case .m4:   (7,   3.2)
        case .m5:   (8,   4)
        case .m6:   (10,  5)
        case .m7:   (11,  5.5)
        case .m8:   (13,  6.5)
        case .m10:  (17,  8)
        case .m12:  (19,  10)
        case .m14:  (22,  11)
        case .m16:  (24,  13)
        case .m18:  (27,  15)
        case .m20:  (30,  16)
        case .m22:  (32,  18)
        case .m24:  (36,  19)
        case .m27:  (41,  22)
        case .m30:  (46,  24)
        case .m33:  (50,  26)
        case .m36:  (55,  29)
        case .m39:  (60,  31)
        case .m42:  (65,  34)
        case .m45:  (70,  36)
        case .m48:  (75,  38)
        case .m52:  (80,  42)
        case .m56:  (85,  45)
        case .m60:  (90,  48)
        case .m64:  (95,  51)
        default: (-1, -1)
        }

        assert(headWidth > 0, "\(size) isn't a valid size for DIN 934 nuts")
        return hex(thread: .isoMetric(size), headWidth: headWidth, headHeight: headHeight, flatDiameter: headWidth * 0.95)
    }

    static func hex(thread: ScrewThread, headWidth: Double, headHeight: Double, flatDiameter dw: Double? = nil) -> PolygonalNut {
        let chamferWidth = RegularPolygon(sideCount: 6, apothem: headWidth / 2).circumradius - (dw ?? headWidth) / 2
        let chamfer = EdgeProfile.chamfer(width: chamferWidth, angle: 30°)
        return .init(thread: thread, sideCount: 6, thickness: headHeight, widthAcrossFlats: headWidth, topCorners: chamfer, bottomCorners: chamfer, innerChamferAngle: 120°)
    }
}
