import Cadova

public extension ScrewThread {
    /// Standard ST1.5 tapping screw thread
    static let st1p5 = tapping(.st1p5)
    /// Standard ST1.9 tapping screw thread
    static let st1p9 = tapping(.st1p9)
    /// Standard ST2.2 tapping screw thread
    static let st2p2 = tapping(.st2p2)
    /// Standard ST2.6 tapping screw thread
    static let st2p6 = tapping(.st2p6)
    /// Standard ST2.9 tapping screw thread
    static let st2p9 = tapping(.st2p9)
    /// Standard ST3.3 tapping screw thread
    static let st3p3 = tapping(.st3p3)
    /// Standard ST3.5 tapping screw thread
    static let st3p5 = tapping(.st3p5)
    /// Standard ST3.9 tapping screw thread
    static let st3p9 = tapping(.st3p9)
    /// Standard ST4.2 tapping screw thread
    static let st4p2 = tapping(.st4p2)
    /// Standard ST4.8 tapping screw thread
    static let st4p8 = tapping(.st4p8)
    /// Standard ST5.5 tapping screw thread
    static let st5p5 = tapping(.st5p5)
    /// Standard ST6.3 tapping screw thread
    static let st6p3 = tapping(.st6p3)
    /// Standard ST8 tapping screw thread
    static let st8   = tapping(.st8)
    /// Standard ST9.5 tapping screw thread
    static let st9p5 = tapping(.st9p5)
}

public extension ScrewThread {
    /// Creates an ISO 1478 tapping screw thread for a given nominal size.
    ///
    /// Tapping screw threads use a 60° profile with a narrow flat crest and widely spaced
    /// turns, leaving a broad flat root. Unlike machine screw threads, they are designed to
    /// form their own mating thread in sheet metal or plastic.
    ///
    /// - Parameter size: The ISO 1478 nominal thread size.
    /// - Returns: A right-hand, single-start tapping screw thread.
    ///
    static func tapping(_ size: TappingSize) -> ScrewThread {
        let metrics = TappingThreadMetrics(size: size)
        return Self(
            pitch: metrics.pitch,
            majorDiameter: metrics.majorDiameter,
            minorDiameter: metrics.coreDiameter,
            form: .trapezoidal(angle: 60°, crestWidth: metrics.crestWidth)
        )
    }

    /// ISO 1478 nominal tapping screw thread sizes.
    enum TappingSize: Double, Sendable {
        /// ST1.5
        case st1p5 = 1.5
        /// ST1.9
        case st1p9 = 1.9
        /// ST2.2
        case st2p2 = 2.2
        /// ST2.6
        case st2p6 = 2.6
        /// ST2.9
        case st2p9 = 2.9
        /// ST3.3
        case st3p3 = 3.3
        /// ST3.5
        case st3p5 = 3.5
        /// ST3.9
        case st3p9 = 3.9
        /// ST4.2
        case st4p2 = 4.2
        /// ST4.8
        case st4p8 = 4.8
        /// ST5.5
        case st5p5 = 5.5
        /// ST6.3
        case st6p3 = 6.3
        /// ST8
        case st8   = 8
        /// ST9.5
        case st9p5 = 9.5
    }
}

public extension ScrewThread.TappingSize {
    /// The ISO 1478 thread for this size.
    var thread: ScrewThread {
        .tapping(self)
    }

    /// The gauge number traditionally used to designate this size.
    var gaugeNumber: Int {
        TappingThreadMetrics(size: self).gaugeNumber
    }
}

/// The end form of a tapping screw, as defined by ISO 1478.
public enum TappingScrewEnd: Sendable {
    /// A cone end, tapering to a point at a 45° included angle. Previously designated type AB.
    ///
    /// Cone end screws start in a pilot hole more easily and are the usual choice for
    /// blind holes in plastic.
    case cone
    /// A blunt flat end. Previously designated type B.
    case flat
}

/// ISO 1478 tapping screw thread dimensions.
///
/// Values are taken from the table in ISO 1478:1983, clause 2, using the maximum column
/// for each diameter. The symbols in the comments are those used by the standard.
internal struct TappingThreadMetrics: Sendable {
    let pitch: Double // P
    let majorDiameter: Double // d1
    let coreDiameter: Double // d2
    let flatEndDiameter: Double // d3
    let crestWidth: Double // c
    /// Length of incomplete thread (y) on a type C cone end.
    let coneEndRunout: Double
    /// Length of incomplete thread (y) on a type F flat end.
    let flatEndRunout: Double
    let gaugeNumber: Int

    init(size: ScrewThread.TappingSize) {
        (pitch, majorDiameter, coreDiameter, flatEndDiameter, crestWidth, coneEndRunout, flatEndRunout, gaugeNumber) = switch size {
        case .st1p5: (0.5, 1.52, 0.91, 0.79, 0.1,  1.4, 1.1, 0)
        case .st1p9: (0.6, 1.90, 1.24, 1.12, 0.1,  1.6, 1.2, 1)
        case .st2p2: (0.8, 2.24, 1.63, 1.47, 0.1,  2.0, 1.6, 2)
        case .st2p6: (0.9, 2.57, 1.90, 1.73, 0.1,  2.3, 1.8, 3)
        case .st2p9: (1.1, 2.90, 2.18, 2.01, 0.1,  2.6, 2.1, 4)
        case .st3p3: (1.3, 3.30, 2.39, 2.21, 0.1,  3.0, 2.5, 5)
        case .st3p5: (1.3, 3.53, 2.64, 2.41, 0.1,  3.2, 2.5, 6)
        case .st3p9: (1.3, 3.91, 2.92, 2.67, 0.1,  3.5, 2.7, 7)
        case .st4p2: (1.4, 4.22, 3.10, 2.84, 0.1,  3.7, 2.8, 8)
        case .st4p8: (1.6, 4.80, 3.58, 3.30, 0.15, 4.3, 3.2, 10)
        case .st5p5: (1.8, 5.46, 4.17, 3.86, 0.15, 5.0, 3.6, 12)
        case .st6p3: (1.8, 6.25, 4.88, 4.55, 0.15, 6.0, 3.6, 14)
        case .st8:   (2.1, 8.00, 6.20, 5.84, 0.15, 7.5, 4.2, 16)
        case .st9p5: (2.1, 9.65, 7.85, 7.44, 0.15, 8.0, 4.2, 20)
        }
    }
}
