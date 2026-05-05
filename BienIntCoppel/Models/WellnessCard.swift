//
//  WellnessCardModel.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 11 on 04/05/26.
//

import SwiftUI

struct WellnessCardModel: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
    let startColor: Color
    let endColor: Color
    let iconColor: Color
    let destination: AnyView?
}
