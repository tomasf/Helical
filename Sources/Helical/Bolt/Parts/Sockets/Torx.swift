import Foundation
import SwiftSCAD

/// Torx hexalobular socket numbers
public enum TorxSize {
    case t6, t8, t10, t15, t20, t25, t30, t40, t45, t50, t55, t60, t70, t80, t90, t100
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
