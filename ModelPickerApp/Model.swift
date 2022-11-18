//
//  Model.swift
//  ModelPickerApp
//
//  Created by 長政輝 on 2022/11/18.
//

import UIKit
import RealityKit
import Combine

class Model {
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        
        self.image = UIImage(named: modelName)!
        
        let fileName = modelName + ".usdz"
        cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion: { loadCompletion  in
                // エラーハンドル
                switch loadCompletion {
                case .finished:
                        break;
                case .failure(let error):
                    print("DEBUG: モデル名 \(modelName) の modelEntity を読み込むことができません error: \(error)")
                }
            }, receiveValue: { modelEntity in
                // モデルエンティティを取得
                self.modelEntity = modelEntity
                print("DEBUG: モデル名 \(modelName) の modelEntity を読み込みました")
            })
    }
}
