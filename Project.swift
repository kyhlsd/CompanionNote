import ProjectDescription

let project = Project(
    name: "CompanionNote",
    targets: [
        .target(
            name: "CompanionNote",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.CompanionNote",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["CompanionNote/Sources/**"],
            resources: ["CompanionNote/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "CompanionNoteTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.CompanionNoteTests",
            infoPlist: .default,
            sources: ["CompanionNote/Tests/**"],
            resources: [],
            dependencies: [.target(name: "CompanionNote")]
        ),
    ]
)
