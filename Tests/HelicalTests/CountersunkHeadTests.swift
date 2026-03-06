import Testing
import Helical
import Cadova

private func isClose(_ a: Double, _ b: Double, tolerance: Double = 1e-9) -> Bool { abs(a - b) < tolerance }

struct CountersunkHeadTests {
    @Test func `height is (topDiameter - boltDiameter) / 2 × tan(angle / 2)`() {
        let noLens = CountersunkBoltHeadShape(angle: 90°, topDiameter: 10, boltDiameter: 5)
        #expect(isClose(noLens.height, 2.5, tolerance: 1e-6))

        // 82° uses angle/2 = 41°, not the full angle
        let angled = CountersunkBoltHeadShape(angle: 82°, topDiameter: 8, boltDiameter: 4)
        #expect(isClose(angled.height, 2.0 * tan(41°), tolerance: 1e-6))
    }

    @Test func `lens height adds to total height but not consumed length`() {
        let shape = CountersunkBoltHeadShape(angle: 90°, topDiameter: 10, boltDiameter: 5, lensHeight: 1)
        #expect(isClose(shape.height, 3.5, tolerance: 1e-6))
        #expect(isClose(shape.consumedLength, 2.5, tolerance: 1e-6))
    }

    @Test func `consumed length equals height minus lens height`() {
        let shape = CountersunkBoltHeadShape(angle: 90°, topDiameter: 12, boltDiameter: 6, lensHeight: 1.5)
        #expect(isClose(shape.consumedLength, shape.height - 1.5))
    }
}
