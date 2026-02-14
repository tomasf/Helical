import Cadova

/// Standard Phillips driver sizes.
public enum PhillipsSize: Sendable {
    /// PH0
    case ph0
    /// PH1
    case ph1
    /// PH2
    case ph2
    /// PH3
    case ph3
    /// PH4
    case ph4
}

internal struct PhillipsMetrics: Sendable {
    let fullWidth: Double
    let crossDistanceBetweenCorners: Double // b
    let cornerWidth: Double // e
    let bottomWidth: Double // g
    let slotWidth: Double // f
    let filletRadius: Double // r
    let cornerAcrossAngle: Angle // α
    let cornerSlant: Angle // β

    let topAngle = 26.5°
    let bottomAngle = 28°

    init(size: PhillipsSize, width: Double) {
        fullWidth = width

        switch size {
        case .ph0:
            crossDistanceBetweenCorners = 0.61
            cornerWidth = 0.3
            bottomWidth = 0.81
            slotWidth = 0.35
            filletRadius = 0.3
            cornerAcrossAngle = 135° //???
            cornerSlant = 7°

        case .ph1:
            crossDistanceBetweenCorners = 0.97
            cornerWidth = 0.45
            bottomWidth = 1.27
            slotWidth = 0.55
            filletRadius = 0.5
            cornerAcrossAngle = 138°
            cornerSlant = 7°

        case .ph2:
            crossDistanceBetweenCorners = 1.47
            cornerWidth = 0.82
            bottomWidth = 2.29
            slotWidth = 0.7
            filletRadius = 0.6
            cornerAcrossAngle = 140°
            cornerSlant = 5.75°

        case .ph3:
            crossDistanceBetweenCorners = 2.41
            cornerWidth = 2.0
            bottomWidth = 3.81
            slotWidth = 0.85
            filletRadius = 0.8
            cornerAcrossAngle = 146°
            cornerSlant = 5.75°

        case .ph4:
            crossDistanceBetweenCorners = 3.48
            cornerWidth = 2.4
            bottomWidth = 5.08
            slotWidth = 1.25
            filletRadius = 1
            cornerAcrossAngle = 153°
            cornerSlant = 7°
        }
    }

    var depth: Double {
        let bottomDepth = bottomWidth / 2.0 * tan(bottomAngle)
        let topDepth = (fullWidth / 2 - bottomWidth / 2) / tan(topAngle)
        return topDepth + bottomDepth
    }
}
