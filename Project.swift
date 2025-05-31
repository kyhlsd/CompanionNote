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
                        "NanumDongHwaDdoBag.ttf",
                        "IropkeBatangM.ttf"
                    ]
                ]
            ),
            sources: ["CompanionNote/Sources/**"],
            resources: ["CompanionNote/Resources/**"],
            dependencies: [
                .target(name: "Core"),
                .target(name: "Features"),
                .target(name: "Shared"),
                .external(name: "FirebaseAuth")
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
                sources: [
                    .glob("Modules/Core/**", excluding: [
                        "Modules/Core/**/Tests/**"
                    ])
                ],
                dependencies: [
                    .target(name: "Shared")
                ]
            ),
        
            .target(
                name: "CoreTests",
                destinations: [.iPhone, .iPad],
                product: .unitTests,
                bundleId: "io.tuist.CoreTests",
                deploymentTargets: .iOS("16.0"),
                infoPlist: .default,
                sources: ["Modules/Core/**/Tests/**"],
                resources: [],
                dependencies: [.target(name: "Core")]
            ),
        
            .target(
                name: "Features",
                destinations: [.iPhone, .iPad],
                product: .framework,
                bundleId: "io.tuist.CompanionNote.features",
                deploymentTargets: .iOS("16.0"),
                infoPlist: .default,
                sources: [
                    .glob("Modules/Features/**", excluding: [
                        "Modules/Features/**/Tests/**"
                    ])
                ],
                resources: ["Modules/Features/**/*.xcassets"],
                dependencies: [
                    .target(name: "Core"),
                    .target(name: "Shared")
                ]
            ),
        
            .target(
                name: "FeatureTests",
                destinations: [.iPhone, .iPad],
                product: .unitTests,
                bundleId: "io.tuist.FeatureTests",
                deploymentTargets: .iOS("16.0"),
                infoPlist: .default,
                sources: ["Modules/Features/**/Tests/**"],
                resources: [],
                dependencies: [
                    .target(name: "Features"),
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
