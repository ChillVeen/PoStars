//
//  CometView.swift
//  Starrr
//
//  Created by Igor Tarantino on 17/03/25.
//

import SwiftUI

struct CometView: View {
    var body: some View {
        
        VStack {
            
            Text("COMET")
                .font(.custom("MontserratAlternates-Bold", size: 80))
            
            CreativeCoding2()
                .frame(maxWidth: .infinity)
            
            Spacer()
        }
    }
}

#Preview {
    CometView()
}
