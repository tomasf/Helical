import Foundation
import Cadova

public extension ScrewThread {
    /// Standard E5.5 Edison screw thread (DIN 40400)
    static let e5p5 = edison(.e5p5)
    /// Standard E10 Edison screw thread (DIN 40400)
    static let e10  = edison(.e10)
    /// Standard E12 Edison screw thread (ANSI C81.67)
    static let e12  = edison(.e12)
    /// Standard E14 Edison screw thread (DIN 40400)
    static let e14  = edison(.e14)
    /// Standard E16 Edison screw thread (DIN 40400)
    static let e16  = edison(.e16)
    /// Standard E17 Edison screw thread (ANSI C81.67)
    static let e17  = edison(.e17)
    /// Standard E18 Edison screw thread (DIN 40400)
    static let e18  = edison(.e18)
    /// Standard E26 Edison screw thread (ANSI C81.67)
    static let e26  = edison(.e26)
    /// Standard E27 Edison screw thread (DIN 40400)
    static let e27  = edison(.e27)
    /// Standard E33 Edison screw thread (DIN 40400)
    static let e33  = edison(.e33)
    /// Standard E39 Edison screw thread (ANSI C81.67)
    static let e39  = edison(.e39)
    /// Standard E40 Edison screw thread (DIN 40400)
    static let e40  = edison(.e40)
}

public extension ScrewThread {
    /// Creates an Edison screw thread for the given size per IEC 60061.
    ///
    /// European sizes use DIN 40400 nominal dimensions; North American sizes
    /// use ANSI C81.67 dimensions.
    ///
    /// - Parameter size: The Edison screw size.
    /// - Returns: A screw thread configured for the specified Edison size.
    ///
    static func edison(_ size: EdisonScrewSize) -> ScrewThread {
        let majorDiameter: Double
        let pitch: Double
        let minorDiameter: Double

        switch size {
        // DIN 40400 (European) sizes
        case .e5p5:
            majorDiameter = 5.5;  pitch = 1.00; minorDiameter = 4.9
        case .e10:
            majorDiameter = 10.0; pitch = 1.81; minorDiameter = 8.8
        case .e14:
            majorDiameter = 14.0; pitch = 2.82; minorDiameter = 12.5
        case .e16:
            majorDiameter = 16.0; pitch = 2.50; minorDiameter = 14.7
        case .e18:
            majorDiameter = 18.0; pitch = 3.00; minorDiameter = 17.0
        case .e27:
            majorDiameter = 27.0; pitch = 3.62; minorDiameter = 24.5
        case .e33:
            majorDiameter = 33.0; pitch = 4.23; minorDiameter = 30.8
        case .e40:
            majorDiameter = 40.0; pitch = 6.35; minorDiameter = 36.3

        // ANSI C81.67 (North American) sizes
        case .e12:
            majorDiameter = 12.0;  pitch = 2.54;  minorDiameter = 10.73
        case .e17:
            majorDiameter = 17.0;  pitch = 2.82;  minorDiameter = 15.62
        case .e26:
            majorDiameter = 26.0;  pitch = 3.63;  minorDiameter = 24.32
        case .e39:
            majorDiameter = 39.0;  pitch = 6.35;  minorDiameter = 36.47
        }

        let h = (majorDiameter - minorDiameter) / 2
        // Tangent-arcs formula: R = (h² + P²/4) / (4h)
        let radius = (h * h + pitch * pitch / 4) / (4 * h)

        return Self(
            pitch: pitch,
            majorDiameter: majorDiameter,
            minorDiameter: minorDiameter,
            form: KnuckleThreadform(crestRadius: radius, rootRadius: radius)
        )
    }

    /// Edison screw sizes per IEC 60061.
    enum EdisonScrewSize: Double {
        // DIN 40400 (European)
        /// E5.5 — Lilliput Edison Screw
        case e5p5 = 5.5
        /// E10 — Miniature Edison Screw
        case e10  = 10
        /// E14 — Small Edison Screw (SES)
        case e14  = 14
        /// E16
        case e16  = 16
        /// E18
        case e18  = 18
        /// E27 — Edison Screw (ES)
        case e27  = 27
        /// E33
        case e33  = 33
        /// E40 — Goliath Edison Screw (GES)
        case e40  = 40

        // ANSI C81.67 (North American)
        /// E12 — Candelabra Edison Screw (CES)
        case e12  = 12
        /// E17 — Intermediate Edison Screw (IES)
        case e17  = 17
        /// E26 — Medium Edison Screw (MES)
        case e26  = 26
        /// E39 — Mogul Edison Screw
        case e39  = 39
    }
}
