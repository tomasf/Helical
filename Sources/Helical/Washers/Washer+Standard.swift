import Foundation

/// Plain washers (ISO 7089, ISO 7093-1).
///
/// Standard metric flat washers in normal and large series.
public extension Washer {
    /// The size series for plain washers.
    enum SizeSeries {
        /// Normal series (ISO 7089).
        case normal
        /// Large series (ISO 7093-1).
        case large
    }

    /// Creates a standard plain washer.
    ///
    /// - Parameters:
    ///   - size: The ISO metric bolt size.
    ///   - series: The size series. Defaults to normal.
    static func plain(_ size: ScrewThread.ISOMetricSize, series: SizeSeries = .normal) -> Washer {
        let innerDiameter: Double // d1
        let outerDiameterSmall: Double // d2, ISO 7089
        let outerDiameterLarge: Double // d2, ISO 7093-1
        let thickness: Double // h

        (innerDiameter, outerDiameterSmall, outerDiameterLarge, thickness) = switch(size) {
        case .m1p6: (1.7,  4,   -1,  0.3)
        case .m2:   (2.2,  5,   -1,  0.3)
        case .m2p5: (2.7,  6,   8,   0.5)
        case .m3:   (3.2,  7,   9,   0.5)
        case .m3p5: (3.7,  8,   11,  0.5)
        case .m4:   (4.3,  9,   12,  0.8)
        case .m5:   (5.3,  10,  15,  1)
        case .m6:   (6.4,  12,  18,  1.6)
        case .m7:   (7.4,  14,  22,  1.6)
        case .m8:   (8.4,  16,  24,  1.6)
        case .m10:  (10.5, 20,  30,  2)
        case .m12:  (13,   24,  37,  2.5)
        case .m14:  (15,   28,  44,  2.5)
        case .m16:  (17,   30,  50,  3)
        case .m18:  (19,   34,  56,  3)
        case .m20:  (21,   37,  60,  3)
        case .m22:  (23,   39,  66,  3)
        case .m24:  (25,   44,  72,  4)
        case .m27:  (28,   50,  85,  4)
        case .m30:  (31,   56,  92,  4)
        case .m33:  (34,   60,  105, 5)
        case .m36:  (37,   66,  110, 5)
        case .m39:  (40,   72,  -1,  6)
        case .m42:  (43,   78,  -1,  7)
        case .m45:  (46,   85,  -1,  7)
        case .m48:  (50,   92,  -1,  8)
        case .m52:  (54,   98,  -1,  8)
        case .m56:  (58,   105, -1,  9)
        case .m60:  (66,   110, -1,  10)
        case .m64:  (70,   115, -1,  10)
        default: (-1, -1, -1, -1)
        }

        let outerDiameter = series == .large ? outerDiameterLarge : outerDiameterSmall
        assert(outerDiameter > 0, "\(size) isn't a valid size for this washer type")

        return Washer(outerDiameter: outerDiameter, innerDiameter: innerDiameter, thickness: thickness)
    }
}
