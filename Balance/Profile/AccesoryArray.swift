//
//  AccesoryArray.swift
//  Balance
//
//  Created by Gonzalo Perisset on 07/08/2023.
//

import SwiftUI

class AccesoryManager: ObservableObject {
    // @Published var accesories = (1...21).map { Accesory(name: "acc_\($0)") }
    @Published var accesories: [Accesory] = [
        Accesory(name: "acc_1", value: 25),
        Accesory(name: "acc_2", value: 50),
        Accesory(name: "acc_3", value: 75),
        Accesory(name: "acc_4", value: 100),
        Accesory(name: "acc_5", value: 500),
        Accesory(name: "acc_6", value: 100),
        Accesory(name: "acc_7", value: 150),
        Accesory(name: "acc_8", value: 300),
        Accesory(name: "acc_9", value: 500),
        Accesory(name: "acc_10", value: 200),
        Accesory(name: "acc_11", value: 100),
        Accesory(name: "acc_12", value: 200),
        Accesory(name: "acc_13", value: 300),
        Accesory(name: "acc_14", value: 200),
        Accesory(name: "acc_15", value: 300),
        Accesory(name: "acc_16", value: 100),
        Accesory(name: "acc_17", value: 150),
        Accesory(name: "acc_18", value: 150),
        Accesory(name: "acc_19", value: 100),
        Accesory(name: "acc_20", value: 100),
        Accesory(name: "acc_21", value: 100)
    ]
}
