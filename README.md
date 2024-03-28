# Helical

Helical is a library for SwiftSCAD that simplifies the creation of threaded components and related parts. It supports widely-used metric threads, bolts, and nuts, as well as the ability to customize these components to fit specific requirements.

[Bolts demo](Sources/Demo/bolts.stl)<br/>
[Nuts and washers demo](Sources/Demo/nutsAndWashers.stl)

## Installation

Integrate Helical into your project with the Swift Package Manager by adding it as a dependency in your `Package.swift` file:

<pre>
let package = Package(
    name: "My3DGadget",
    platforms: [.macOS(.v14)], // Needed on macOS
    dependencies: [
        .package(url: "https://github.com/tomasf/SwiftSCAD.git", branch: "main"),
        <b><i>.package(url: "https://github.com/tomasf/Helical.git", branch: "main")</i></b>
    ],
    targets: [
        .executableTarget(name: "My3DGadget", dependencies: [
            "SwiftSCAD",
            <b><i>"Helical"</i></b>
        ])
    ]
)
</pre>

Then, import Helical where it's needed:
```swift
import Helical
```

## Usage
### Standard Components
Helical simplifies the process of creating threaded shapes, making it easier to incorporate threaded holes into your models. It also provides a selection of standard bolts, nuts, and corresponding holes. Creating a typical M8x30 hex head bolt is simple:

```swift
Bolt.hexHead(.m8, length: 30, shankLength: 8)
```

This generates a standard [DIN 931](https://www.fasteners.eu/standards/DIN/931/) bolt, exactly as anticipated.

### Customizing Components
Beyond the standard offerings, Helical allows for modifications to fit unique requirements:

```swift
Bolt.hexHead(.isoMetric(.m8, pitch: 0.75), headWidth: 15, headHeight: 6.5, length: 30)
```

Or fully customize parts to your specific needs:

```swift
let thread = ScrewThread(
    handedness: .left,
    starts: 2,
    pitch: 1.5,
    majorDiameter: 6.2,
    minorDiameter: 5.3,
    form: .trapezoidal(angle: 90°, crestWidth: 0.25)
)
let customBolt = Bolt(
    thread: thread,
    length: 15,
    shankLength: 3,
    shankDiameter: 5,
    headShape: .countersunk(angle: 80°, topDiameter: 10, boltDiameter: 5),
    socket: .slotted(length: 10, width: 1, depth: 1.4)
)
```

### Holes

Creating a matching countersunk clearance hole for a bolt is straightforward:

```swift
Box([20, 20, 10], center: .xy)
    .subtracting {
        customBolt.clearanceHole(recessedHead: true)
    }
```

As is making a threaded hole for a particular thread:

```swift
Box([20, 20, 10], center: .xy)
    .subtracting {
        ThreadedHole(thread: thread, depth: 10, unthreadedDepth: 2)
    }
```

## Contributing

We welcome contributions. Feel free to open issues for feedback or suggestions and submit pull requests for improvements to the codebase.

