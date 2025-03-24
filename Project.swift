import ProjectDescription

let project = Project(
    name: "CompanionNote",
    options: .options(
        automaticSchemesOptions: .disabled,
        defaultKnownRegions: ["en", "ko"],
        developmentRegion: "ko",
        textSettings: .textSettings(usesTabs: false, indentWidth: 4, tabWidth: 4)
    ),
    targets: [
        .target(
            name: "CompanionNote",
            destinations: [.iPhone, .iPad],
            product: .app,
            bundleId: "io.tuist.CompanionNote",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ],
                            ]
                        ]
                    ],
                    "UIAppFonts": [
                        "NanumDongHwaDdoBag.ttf"
                    ]
                ]
            ),
            sources: ["CompanionNote/Sources/**"],
            resources: ["CompanionNote/Resources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "Features"),
                .target(name: "Shared")
            ]
        ),
        .target(
            name: "CompanionNoteTests",
            destinations: [.iPhone, .iPad],
            product: .unitTests,
            bundleId: "io.tuist.CompanionNoteTests",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .default,
            sources: ["CompanionNote/Tests/**"],
            resources: [],
            dependencies: [.target(name: "CompanionNote")]
        ),
        
            .target(
                name: "Core",
                destinations: [.iPhone, .iPad],
                product: .framework,
                bundleId: "io.tuist.CompanionNote.core",
                deploymentTargets: .iOS("16.0"),
                infoPlist: .default,
                sources: ["Modules/Core/**"],
                dependencies: [
                    .target(name: "Shared")
                ]
            ),
        
            .target(
                name: "Features",
                destinations: [.iPhone, .iPad],
                product: .framework,
                bundleId: "io.tuist.CompanionNote.features",
                deploymentTargets: .iOS("16.0"),
                infoPlist: .default,
                sources: ["Modules/Features/**"],
                resources: ["Modules/Features/**/*.xcassets"],
                dependencies: [
                    .target(name: "Core"),
                    .target(name: "Shared")
                ]
            ),
        
            .target(
                name: "Shared",
                destinations: [.iPhone, .iPad],
                product: .framework,
                bundleId: "io.tuist.CompanionNote.shared",
                deploymentTargets: .iOS("16.0"),
                infoPlist: .default,
                sources: ["Modules/Shared/**"],
                resources: ["Modules/Shared/**/*.xcassets"],
                dependencies: []
            ),
    ]
)
