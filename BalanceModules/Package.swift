// swift-tools-version: 5.7

//
// This source file is part of the CS342 2023 Balance Team Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "BalanceModules",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "BalanceContacts", targets: ["BalanceContacts"]),
        .library(name: "BalanceMockDataStorageProvider", targets: ["BalanceMockDataStorageProvider"]),
        .library(name: "BalanceOnboardingFlow", targets: ["BalanceOnboardingFlow"]),
        .library(name: "BalanceSchedule", targets: ["BalanceSchedule"]),
        .library(name: "BalanceSharedContext", targets: ["BalanceSharedContext"])
    ],
    dependencies: [
        .package(url: "https://github.com/StanfordBDHG/CardinalKit.git", .upToNextMinor(from: "0.3.1"))
    ],
    targets: [
        .target(
            name: "BalanceContacts",
            dependencies: [
                .target(name: "BalanceSharedContext"),
                .product(name: "Contact", package: "CardinalKit")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "BalanceMockDataStorageProvider",
            dependencies: [
                .target(name: "BalanceSharedContext"),
                .product(name: "CardinalKit", package: "CardinalKit"),
                .product(name: "FHIR", package: "CardinalKit")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "BalanceOnboardingFlow",
            dependencies: [
                .target(name: "BalanceSharedContext"),
                .product(name: "Account", package: "CardinalKit"),
                .product(name: "FHIR", package: "CardinalKit"),
                .product(name: "FirebaseAccount", package: "CardinalKit"),
                .product(name: "HealthKitDataSource", package: "CardinalKit"),
                .product(name: "Onboarding", package: "CardinalKit"),
                .product(name: "Views", package: "CardinalKit")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "BalanceSchedule",
            dependencies: [
                .target(name: "BalanceSharedContext"),
                .product(name: "FHIR", package: "CardinalKit"),
                .product(name: "Questionnaires", package: "CardinalKit"),
                .product(name: "Scheduler", package: "CardinalKit")
            ]
        ),
        .target(
            name: "BalanceSharedContext",
            dependencies: []
        )
    ]
)
