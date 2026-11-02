import Testing
@testable import Helical
import Cadova

private func isClose(_ a: Double, _ b: Double, tolerance: Double = 1e-9) -> Bool { abs(a - b) < tolerance }

private let allTappingSizes: [ScrewThread.TappingSize] = [
    .st1p5, .st1p9, .st2p2, .st2p6, .st2p9, .st3p3, .st3p5,
    .st3p9, .st4p2, .st4p8, .st5p5, .st6p3, .st8, .st9p5
]

struct TappingThreadTests {
    // Unlike ISO metric threads, every diameter here is tabulated rather than derived,
    // so these spot checks guard against transcription errors in the ISO 1478 table.
    @Test func `thread dimensions come from the ISO 1478 table`() {
        #expect(isClose(ScrewThread.st2p9.pitch, 1.1))
        #expect(isClose(ScrewThread.st2p9.majorDiameter, 2.90))
        #expect(isClose(ScrewThread.st2p9.minorDiameter, 2.18))

        #expect(isClose(ScrewThread.st3p5.pitch, 1.3))
        #expect(isClose(ScrewThread.st3p5.majorDiameter, 3.53))
        #expect(isClose(ScrewThread.st3p5.minorDiameter, 2.64))

        #expect(isClose(ScrewThread.st6p3.pitch, 1.8))
        #expect(isClose(ScrewThread.st6p3.majorDiameter, 6.25))
        #expect(isClose(ScrewThread.st6p3.minorDiameter, 4.88))
    }

    // ISO 1478 marks y as a reference value, but it is not independent: the cone end
    // runs out exactly where the 45° cone drops below the core diameter. Reproducing the
    // tabulated y from d2 alone confirms both the core diameters and that the 45° in the
    // standard's figure is the included angle rather than the half angle.
    //
    // ST1.5 and ST9.5 are the two sizes at the ends of the range where the tabulated y
    // departs from this relationship.
    @Test func `cone end runout follows from the core diameter and the 45° cone`() {
        for size in allTappingSizes where size != .st1p5 && size != .st9p5 {
            let metrics = TappingThreadMetrics(size: size)
            let derived = (metrics.coreDiameter / 2) / tan(22.5°)
            #expect(isClose(metrics.coneEndRunout, derived, tolerance: 0.15), "\(size)")
        }
    }

    // A pitch below the threadform's minimum makes adjacent turns overlap, which the
    // ScrewThread initializer only catches via assert — in release builds it produces
    // invalid geometry silently.
    @Test func `every size clears the threadform's minimum pitch`() {
        for size in allTappingSizes {
            let thread = ScrewThread.tapping(size)
            #expect(thread.pitch >= thread.form.minimumPitch(for: thread), "\(size)")
        }
    }

    @Test func `crest width switches from 0.1 to 0.15 above ST4.2`() {
        #expect(isClose(TappingThreadMetrics(size: .st4p2).crestWidth, 0.1))
        #expect(isClose(TappingThreadMetrics(size: .st4p8).crestWidth, 0.15))
    }
}

struct PhillipsCountersunkTappingTests {
    // DIN 7982 heads are 80°, not the 90° of the metric machine screw standards.
    //
    // The head is modelled as the cone actually present on the screw: from dk down to where
    // it meets the thread. The standard's k is larger, because it is measured to the sharp
    // corner that the rounded or flat edge replaces — a theoretical reference rather than the
    // height of any metal. Driving the model from k would sink the screw below flush.
    @Test func `head is an 80 degree cone from dk down to the thread`() {
        let expected: [(ScrewThread.TappingSize, dk: Double, k: Double)] = [
            (.st2p2, 4.3, 1.3), (.st2p9, 5.5, 1.7), (.st3p5, 6.8, 2.1), (.st3p9, 7.5, 2.3),
            (.st4p2, 8.1, 2.5), (.st4p8, 9.5, 3.0), (.st5p5, 10.8, 3.4), (.st6p3, 12.4, 3.8)
        ]
        for (size, dk, k) in expected {
            let bolt = Bolt.phillipsCountersunkTapping(size, length: 20)
            guard let head = bolt.headShape as? CountersunkBoltHeadShape else {
                Issue.record("\(size) has no countersunk head"); continue
            }
            #expect(head.countersink.angle == 80°, "\(size)")
            #expect(isClose(head.countersink.topDiameter, dk), "\(size)")

            let cone = ((dk - bolt.thread.majorDiameter) / 2) / tan(40°)
            #expect(isClose(head.height, cone, tolerance: 1e-9), "\(size)")
            #expect(head.height < k, "\(size)")
        }
    }

    // The thread runs up to the head, leaving only the one pitch of run-out (a) that
    // DIN 7982 allows.
    @Test func `thread starts one pitch below the head`() {
        let bolt = Bolt.phillipsCountersunkTapping(.st3p5, length: 20)
        #expect(isClose(bolt.unthreadedLength, bolt.headShape.consumedLength + 1.3))

        #expect(isClose(bolt.unthreadedDiameter, 3.53))
    }

    @Test func `cone end reaches the nominal length`() {
        let point = ConeEndBoltPoint()
        // A 45° cone spans half the major diameter radially, so it is d1 / (2·tan(22.5°)) long.
        #expect(isClose(point.length(for: .st3p5), 3.53 / 2 / tan(22.5°), tolerance: 1e-9))
        #expect(point.consumedLength == 0)
    }
}

struct PhillipsPanHeadTappingTests {
    // DIN 7981 gives the head its own dk, k and rf, unlike the countersunk screws where the
    // height follows from the countersink formula. A transcription error would show up here.
    @Test func `head dimensions match the DIN 7981 table`() {
        let expected: [(ScrewThread.TappingSize, dk: Double, k: Double, rf: Double)] = [
            (.st2p2, 4.2, 1.8, 3.4), (.st2p9, 5.6, 2.2, 4.4),
            (.st3p5, 6.9, 2.6, 5.4), (.st4p8, 9.5, 3.55, 7.2),
            (.st6p3, 12.5, 4.55, 9.5)
        ]
        for (size, dk, k, rf) in expected {
            guard let head = Bolt.phillipsPanHeadTapping(size, length: 16).headShape as? CylindricalBoltHeadShape else {
                Issue.record("\(size) has no cylindrical head shape")
                continue
            }
            #expect(isClose(head.diameter, dk), "\(size)")
            #expect(isClose(head.height, k), "\(size)")
            #expect(isClose(head.roundedTopRadius ?? 0, rf), "\(size)")
        }
    }

    // A pan head sits entirely above the surface, so the nominal length is the shank alone.
    @Test func `pan head consumes none of the nominal length`() {
        let bolt = Bolt.phillipsPanHeadTapping(.st3p5, length: 16)
        #expect(bolt.headShape.consumedLength == 0)
        #expect(isClose(bolt.unthreadedLength, 1.3))
        #expect(isClose(bolt.unthreadedDiameter, 3.53))
    }
}

struct TappingHoleTests {
    // The hole takes the screw's minor diameter, so the core passes through while the
    // thread crests bite into the material around it.
    @Test func `hole diameter is the thread's minor diameter`() {
        #expect(isClose(TappingHole(thread: .st3p5, depth: 10).diameter, 2.64))
        #expect(isClose(TappingHole(thread: .st4p8, depth: 10).diameter, 3.58))
        #expect(isClose(TappingHole(diameter: 2.9, depth: 10).diameter, 2.9))
    }

    // The hole is measured from the surface the screw enters, and spans the nominal length
    // for both head types: a countersunk head is inside that length and sinks into its
    // recess, while a pan head's length is measured below the head.
    @Test func `hole from a bolt spans the nominal length`() {
        for bolt in [Bolt.phillipsCountersunkTapping(.st3p5, length: 20),
                     Bolt.phillipsPanHeadTapping(.st3p5, length: 20)] {
            let hole = bolt.tappingHole()
            #expect(isClose(hole.depth, 20))
            #expect(isClose(hole.diameter, 2.64))
        }
    }
}
