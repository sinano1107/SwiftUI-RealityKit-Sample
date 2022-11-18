//
//  ContentView.swift
//  ModelPickerApp
//
//  Created by 長政輝 on 2022/11/18.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State private var isPlacementEnabled = false
    @State private var selectedModel: String?
    @State private var modelConfirmForPlacement: String?
    
    private var models: [String] = {
        // モデルのファイル名を動的に取得する
        let fileManager = FileManager.default
        
        guard let path = Bundle.main.resourcePath, let files = try? fileManager.contentsOfDirectory(atPath: path) else {
            return []
        }
        
        var availableModels: [String] = []
        for fileName in files where fileName.hasSuffix("usdz") {
            let modelName = fileName.replacingOccurrences(of: ".usdz", with: "")
            availableModels.append(modelName)
        }
        
        return availableModels
    }()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelConfirmedForPlacement: $modelConfirmForPlacement).edgesIgnoringSafeArea(.all)
            
            if isPlacementEnabled {
                PlacementButtonsView(isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel, modelConfirmedForPlacement: $modelConfirmForPlacement)
            } else {
                ModelPickerView(isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel, models: models)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedForPlacement: String?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let modelName = modelConfirmedForPlacement {
            print("DEBUG: シーンにモデルを追加 - \(modelName)")
            
            DispatchQueue.main.async {
                modelConfirmedForPlacement = nil
            }
        }
    }
    
}

struct ModelPickerView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: String?
    
    var models: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(0 ..< models.count, id: \.self) { index in
                    let model = models[index]
                    Button {
                        print("DEBUG: モデル「\(model)」を選択")
                        
                        selectedModel = model
                        
                        isPlacementEnabled = true
                    } label: {
                        Image(uiImage: UIImage(named: model)!)
                            .resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1, contentMode: .fit)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(20)
        }
        .background(Color.black.opacity(0.5))
    }
}

struct PlacementButtonsView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel: String?
    @Binding var modelConfirmedForPlacement: String?
    
    var body: some View {
        HStack {
            // キャンセルボタン
            Button {
                print("DEBUG: モデルの配置をキャンセル")
                
                resetPlacementParameters()
            } label: {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            
            // 確定ボタン
            Button {
                print("DEBUG: モデルの配置を確定")
                
                modelConfirmedForPlacement = selectedModel
                
                resetPlacementParameters()
            } label: {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
    }
    
    func resetPlacementParameters() {
        isPlacementEnabled = false
        selectedModel = nil
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
