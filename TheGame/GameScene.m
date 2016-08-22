//
//  GameScene.m
//  TheGame
//
//  Created by Tim Na on 7/26/15.
//  Copyright (c) 2015 na. All rights reserved.
//

#import "GameScene.h"

#include <math.h>

@implementation GameScene

CGFloat radian_ = 0;

-(void)didMoveToView:(SKView *)view {
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, -2.0f);
    
    SKAction* move = [SKAction moveByX:-1500.0 y:0.0 duration:2.8];
    move = [SKAction repeatActionForever:move];
    
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Geomety Dash";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    myLabel.name = @"LABEL";
    [myLabel runAction:move];
    
    [self addChild:myLabel];
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"pacman2"];
    sprite.name = @"PACMAN";
    sprite.xScale = 0.2;
    sprite.yScale = 0.2;
    sprite.position = CGPointMake(300, 10);
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    sprite.physicsBody.dynamic = YES;
    sprite.physicsBody.mass = 0.5f;
    sprite.physicsBody.affectedByGravity = YES;
    sprite.physicsBody.allowsRotation = YES;
    sprite.physicsBody.restitution = 0.0f;
    sprite.physicsBody.friction = 0.0f;
    sprite.physicsBody.angularDamping = 0.0f;
    sprite.physicsBody.linearDamping = 0.0f;
    [self addChild:sprite];
    
    SKSpriteNode* triangle = [SKSpriteNode spriteNodeWithImageNamed:@"triangle"];
    triangle.name   = @"TRIANGLE";
    triangle.xScale = 0.7;
    triangle.yScale = 0.7;
    triangle.position = CGPointMake(1200, 10);
    [triangle runAction:move];
    [self addChild:triangle];
    
    SKSpriteNode* square = [SKSpriteNode spriteNodeWithImageNamed:@"square"];
    square.name   = @"SQUARE";
    square.xScale = 0.5;
    square.yScale = 0.5;
    square.position = CGPointMake(1500, 35);
    //square.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:square.size];
    square.physicsBody.dynamic = YES;
    square.physicsBody.affectedByGravity = NO;
    square.physicsBody.mass = 0.5f;
    [square runAction:move];
    [self addChild:square];
    
    self.backgroundColor = [SKColor colorWithRed:0.5 green:0.2 blue:0.7 alpha:1.0];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
}


-(void) jump {
    SKNode* p_node = [self childNodeWithName:@"PACMAN"];
    SKSpriteNode* pacman = (SKSpriteNode*)p_node;

    static bool toggle = false;
    
    radian_ = (toggle ? 0 : -M_PI);
    toggle  = (toggle ? false : true);
    
    SKAction *rise = [SKAction moveByX:0 y:250 duration:0.3];
    SKAction *fall = [SKAction moveByX:0 y:-250 duration:0.3];
    SKAction *spin = [SKAction rotateToAngle:radian_ duration:0.5];
    SKAction *jump = [SKAction sequence:@[rise, fall]];
    SKAction *mix  = [SKAction group:@[jump, spin]];
    
    [pacman runAction:mix];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//    }
    SKNode* p_node = [self childNodeWithName:@"PACMAN"];
    SKSpriteNode* pacman = (SKSpriteNode*)p_node;
    
    p_node = [self childNodeWithName:@"SQUARE"];
    SKSpriteNode* p_square = (SKSpriteNode*)p_node;
    
    printf("pacman %f/%f square %f/%f\n",
           pacman.position.x, pacman.position.y,
           p_square.position.x, p_square.position.y);
    
    if (pacman.position.y < 55) {
        [self jump];
    }
    else { // case for jump on top of square
        if (p_square.position.x-100 <= pacman.position.x &&
            pacman.position.x <= p_square.position.x+100 &&
            p_square.position.y <= pacman.position.y &&
            pacman.position.y <= p_square.position.y+200 ) {
            printf("pacman %f/%f square %f/%f\n",
                   pacman.position.x, pacman.position.y,
                   p_square.position.x, p_square.position.y);

            [pacman removeAllActions];
            [self jump];
        }
    }
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    SKNode* node = [self childNodeWithName:@"LABEL"];
    SKLabelNode* label = (SKLabelNode*)node;
    
    if (label.position.x+300 < 0) {
        label.position = CGPointMake(1200, CGRectGetMidY(self.frame));
    }
    
    node = [self childNodeWithName:@"SQUARE"];
    SKSpriteNode* obstacle = (SKSpriteNode*)node;
    if (obstacle.position.x < 0) {
        obstacle.position = CGPointMake(1500, 35);
    }
    
    node = [self childNodeWithName:@"TRIANGLE"];
    obstacle = (SKSpriteNode*)node;
    if (obstacle.position.x < 0) {
        obstacle.position = CGPointMake(1200, 0);
    }    
}


@end
