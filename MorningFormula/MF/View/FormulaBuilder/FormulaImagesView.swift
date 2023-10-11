//
//  FormulaImagesView.swift
//  MorningFormula
//
//  Created by Spencer Belton on 10/10/23.
//

import SwiftUI
import PhotosUI

struct FormulaImagesView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @ObservedObject var formulaManager = FormulaManager.instance
    @State var selectedImage: PhotosPickerItem? = nil
    
    let width = (UIScreen().bounds.width / 3)
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                CapsuleProgressView(
                    progress: 3,
                    pageCount: formulaManager.formulaPageCount)
                titleView
                subtitleView
                imagesList(geo)
                Spacer()
                HStack {
                    previousButton
                    Spacer()
                    nextButton
                }
                
            }
        }
        .navigationBarBackButtonHidden()
        
    }
    
    var titleView: some View {
        Text("Add Powerful Images")
            .font(.title)
    }
    
    var subtitleView: some View {
        Text("Use images that motivate you or are a part of your vision.")
//            .font(.caption)
//            .foregroundColor(.gray)
            .font(.headline)
            .foregroundColor(.gray)
        
    }
    
    func imagesList(_ geo: GeometryProxy) -> some View {
        LazyVGrid(columns: gridItems(geo), spacing: 8) {
            ForEach(formulaManager.images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 120)
            }
            photosPicker(geo)

        }
    }
    
    func photosPicker(_ geo: GeometryProxy) -> some View {
        let imageWidth = geo.size.width / 3
        return PhotosPicker(selection: $selectedImage) {
            ZStack {
                Rectangle()
                    .fill(.gray)
                    .frame(width: imageWidth, height: imageWidth)
                Image(systemName: "plus")
                    .foregroundColor(.yellow)
                    
            }
        }
        .onChange(of: selectedImage) { _ in
            Task {
                if let data = try? await selectedImage?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        formulaManager.images.append(uiImage)
                        return
                    }
                }
            }
        }
    }
    
    func gridItems(_ geo: GeometryProxy) -> [GridItem] {
        let size = geo.size.width / 3
        return [
            GridItem(.fixed(size)),
            GridItem(.fixed(size)),
            GridItem(.fixed(size))
        ]
    }
    
    var nextButton: some View {
        NavigationLink {
            FormulaBuilderView()
                .padding()
        } label: {
            Text("Next")
        }
    }
    
    var previousButton: some View {
        Button {                
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Previous")
        }
    }
}

struct FormulaImagesView_Previews: PreviewProvider {
    static var previews: some View {
        FormulaImagesView()
            .padding()
    }
}
