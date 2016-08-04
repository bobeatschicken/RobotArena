//
//  Bullet.swift
//  RobotArena
//
//  Created by Christopher Yang on 7/21/16.
//  Copyright © 2016 MakeSchool. All rights reserved.
//
import SpriteKit

class Bullet: SKSpriteNode {

/* You are required to implement this for your subclass to work */
override init(texture: SKTexture?, color: UIColor, size: CGSize) {
    super.init(texture: texture, color: color, size: size)
}

/* You are required to implement this for your subclass to work */
required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
}
}