import Foundation
import Cadova

internal struct SolidThreadform: Threadform {
    func shape(for thread: ScrewThread) -> any Geometry2D {
        Rectangle(x: thread.depth, y: thread.pitch)
    }

    func pitchDiameter(for thread: ScrewThread) -> Double {
        thread.majorDiameter
    }
}
