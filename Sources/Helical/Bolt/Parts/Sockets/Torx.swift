import Cadova

/// Standard Torx (hexalobular) driver sizes.
public enum TorxSize: Sendable {
    /// T6
    case t6
    /// T8
    case t8
    /// T10
    case t10
    /// T15
    case t15
    /// T20
    case t20
    /// T25
    case t25
    /// T30
    case t30
    /// T40
    case t40
    /// T45
    case t45
    /// T50
    case t50
    /// T55
    case t55
    /// T60
    case t60
    /// T70
    case t70
    /// T80
    case t80
    /// T90
    case t90
    /// T100
    case t100
}

internal extension TorxSize {
    var outerDiameter: Double {
        switch self {
        case .t6:   1.75
        case .t8:   2.4
        case .t10:  2.8
        case .t15:  3.35
        case .t20:  3.95
        case .t25:  4.5
        case .t30:  5.6
        case .t40:  6.75
        case .t45:  7.93
        case .t50:  8.95
        case .t55:  11.35
        case .t60:  13.45
        case .t70:  15.7
        case .t80:  17.75
        case .t90:  20.2
        case .t100: 22.4
        }
    }
}
