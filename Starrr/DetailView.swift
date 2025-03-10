//
//  DetailView.swift
//  Starrr
//
//  Created by Igor Tarantino on 27/02/25.
//

import SwiftUI

struct DetailView: View {
    let object: [String]
    let fields: [String]

    var body: some View {
        List {
            Section(header: Text("Object Details")) {
                ForEach(0..<object.count, id: \.self) { index in
                    if fields[index] == "Rise time" ||
                        fields[index] == "Set time" ||
                        fields[index] == "Transit time" ||
                        fields[index] == "Max. time observable" ||
                        fields[index] == "Vmag" ||
                        fields[index] == "Dec." ||
                        fields[index] == "R.A." ||
                        fields[index] == "Helio. range (au)" ||
                        fields[index] == "Topo. range (au)" {
                        
                        VStack(alignment: .leading) {
                            Text(fields[index])
                                .font(.headline)
                            Text(object[index])
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .navigationTitle(object[1]) // Full name
    }
}
