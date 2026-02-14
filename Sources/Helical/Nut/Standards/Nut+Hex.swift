import Cadova

/// Hex nuts (DIN 934, ISO 4032).
///
/// Standard metric hex nuts with chamfered corners.
/// Reference: <https://www.fasteners.eu/standards/DIN/934/>
public extension Nut {
    /// Creates a standard DIN 934 hex nut.
    ///
    /// - Parameter size: The ISO metric thread size.
    static func hex(_ size: ScrewThread.ISOMetricSize) -> Nut {
        let width: Double // s, width across flats
        let height: Double // m

        (width, height) = switch size {
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

        if !(width > 0) { fatalError("\(size) isn't a valid size for DIN 934 nuts") }
        return hex(thread: .isoMetric(size), width: width, height: height, flatDiameter: width * 0.95)
    }

    /// Creates a hex nut with custom dimensions.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - width: Width across the flats.
    ///   - height: Height of the nut.
    ///   - flatDiameter: Diameter of the flat portion after chamfering.
    static func hex(thread: ScrewThread, width: Double, height: Double, flatDiameter dw: Double? = nil) -> Nut {
        let chamferWidth = RegularPolygon(sideCount: 6, apothem: width / 2).circumradius - (dw ?? width) / 2
        let shape = PolygonalNutBody(
            sideCount: 6,
            thickness: height,
            widthAcrossFlats: width,
            chamferAngle: 30°,
            topChamferDepth: chamferWidth,
            bottomChamferDepth: chamferWidth
        )
        return Nut(thread: thread, shape: shape, innerChamferAngle: 120°)
    }
}

/// Flanged hex nuts (DIN EN 1661, ISO 4161).
///
/// Hex nuts with an integrated washer-like flange. Extended with M3 and M4 sizes.
/// Reference: <https://www.fasteners.eu/standards/din/6923/>
public extension Nut {
    /// Creates a standard flanged hex nut.
    ///
    /// - Parameter size: The ISO metric thread size.
    static func flangedHex(_ size: ScrewThread.ISOMetricSize) -> Nut {
        let (width, thickness, bottomDiameter, roundingDiameter) = switch size {
        case .m3:  (5.5,  4.0,  6.7,   0.65)
        case .m4:  (7.0,  4.65, 8.6,   0.8)
        case .m5:  (8.0,  5.0,  9.8,   1.0)
        case .m6:  (10.0, 6.0,  12.2,  1.1)
        case .m8:  (13.0, 8.0,  15.8,  1.2)
        case .m10: (15.0, 10.0, 19.6,  1.5)
        case .m12: (18.0, 12.0, 23.8,  1.8)
        case .m14: (21.0, 14.0, 27.6,  2.1)
        case .m16: (24.0, 16.0, 31.9,  2.4)
        case .m20: (30.0, 20.0, 39.9,  3.0)
        default: (0, 0, 0, 0)
        }

        if !(width > 0) { fatalError("\(size) isn't a valid size for flanged hex nuts") }
        return Nut.flangedHex(
            thread: .isoMetric(size),
            width: width,
            height: thickness,
            bottomDiameter: bottomDiameter,
            roundingDiameter: roundingDiameter,
            flangeAngle: 20°
        )
    }

    /// Creates a flanged hex nut with custom dimensions.
    ///
    /// - Parameters:
    ///   - thread: The screw thread specification.
    ///   - width: Width across the flats of the hex portion.
    ///   - height: Height of the hex portion.
    ///   - bottomDiameter: Diameter at the bottom of the flange.
    ///   - roundingDiameter: Diameter of the rounding at the flange edge.
    ///   - flangeAngle: Angle of the flange surface from horizontal.
    static func flangedHex(
        thread: ScrewThread,
        width: Double,
        height: Double,
        bottomDiameter: Double,
        roundingDiameter: Double,
        flangeAngle: Angle
    ) -> Nut {
        let base = hex(thread: thread, width: width, height: height)
        let flangedBody = FlangedNutBody(
            base: base.shape,
            bottomDiameter: bottomDiameter,
            roundingDiameter: roundingDiameter,
            angle: flangeAngle
        )
        return Nut(thread: thread, shape: flangedBody, innerChamferAngle: 120°)
    }
}
