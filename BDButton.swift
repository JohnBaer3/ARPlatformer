//
//  BDButton.swift
//  WaluigiAR
//
//  Created by John Baer on 11/19/18.
//  Copyright © 2018 John Baer. All rights reserved.
//

import SpriteKit

class BDButton: SKNode{
    var button: SKSpriteNode
    private var mask: SKSpriteNode
    private var cropNode: SKCropNode
    private var action: () -> Void
    
    init(imageNamed: String, buttonAction: @escaping () -> Void){
        button = SKSpriteNode(imageNamed: imageNamed)
        
        mask = SKSpriteNode(color: SKColor.black, size: button.size)
        mask.alpha = 0
        
        cropNode = SKCropNode()
        cropNode.maskNode = button
        cropNode.zPosition = 3
        cropNode.addChild(mask)
        
        action = buttonAction
        
        super.init()
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNodes(){
        button.zPosition = 0
    }
    
    func addNodes(){
        addChild(button)
        addChild(cropNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isEnabled{
            mask.alpha = 0.5
            run(SKAction.scale(by))
        }
    }
    
}
