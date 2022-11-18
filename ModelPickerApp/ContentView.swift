//
//  ContentView.swift
//  ModelPickerApp
//
//  Created by 長政輝 on 2022/11/18.
//

import SwiftUI
import RealityKit

struct ContentView : View {
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
            ARViewContainer().edgesIgnoringSafeArea(.all)
            
             ModelPickerView(models: models)
            
            PlacementButtonsView()
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

struct ModelPickerView: View {
    var models: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(0 ..< models.count, id: \.self) { index in
                    let model = models[index]
                    Button {
                        print("DEBUG: モデル「\(model)」を選択")
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
    var body: some View {
        HStack {
            // キャンセルボタン
            Button {
                print("DEBUG: モデルの配置をキャンセル")
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
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
