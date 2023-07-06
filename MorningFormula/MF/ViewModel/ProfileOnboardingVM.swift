//
//  ProfileOnboardingVM.swift
//  MorningFormula
//
//  Created by Spencer Belton on 7/4/23.
//

import SwiftUI
import PhotosUI

class ProfileOnboardingVM: ObservableObject {
    
    static let instance = ProfileOnboardingVM()
    
    @Published var genderIsMale = true
    @Published var genderIsFemale = false
    
    @Published var selectedImage: PhotosPickerItem?
    @Published var images: [UIImage] = []

    
}
