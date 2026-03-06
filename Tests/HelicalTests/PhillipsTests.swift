import Testing
@testable import Helical
import Cadova

private func isClose(_ a: Double, _ b: Double) -> Bool { abs(a - b) < 1e-9 }

// PhillipsMetrics.depth applies a two-term trig formula to stored constants.
// These tests verify that both the stored constants and the formula are correct
// by computing the expected depth from the ISO 4757 spec values independently.
// depth = bottomWidth/2 × tan(28°) + (fullWidth/2 − bottomWidth/2) / tan(26.5°)
struct PhillipsTests {
    @Test func `PH0 depth matches formula with spec constants`() {
        let m = PhillipsMetrics(size: .ph0, width: 1.8)
        let expected = 0.81 / 2 * tan(28°) + (1.8 / 2 - 0.81 / 2) / tan(26.5°)
        #expect(isClose(m.depth, expected))
    }

    @Test func `PH2 depth matches formula with spec constants`() {
        let m = PhillipsMetrics(size: .ph2, width: 4.6)
        let expected = 2.29 / 2 * tan(28°) + (4.6 / 2 - 2.29 / 2) / tan(26.5°)
        #expect(isClose(m.depth, expected))
    }

    @Test func `PH4 depth matches formula with spec constants`() {
        let m = PhillipsMetrics(size: .ph4, width: 9)
        let expected = 5.08 / 2 * tan(28°) + (9.0 / 2 - 5.08 / 2) / tan(26.5°)
        #expect(isClose(m.depth, expected))
    }
}
