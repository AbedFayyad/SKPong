//
//  GameScene.m
//  MyPong
//
//  Created by Abed Fayyad on 2015-09-03.
//  Copyright (c) 2015 Abed Fayyad. All rights reserved.
//

#import "GameScene.h"

#define       PADDING  20.0
#define BORDER_HEIGHT  20.0
#define DIVIDER_WIDTH  10.0
#define DIVIDER_SPACE  10.0
#define PADDLE_HEIGHT 100.0
#define  PADDLE_WIDTH  10.0
#define  PADDLE_SPEED 250.0
#define     BALL_SIZE  10.0
#define    BALL_SPEED 300.0

SKShapeNode *paddle[2];
SKShapeNode *ball;
SKPhysicsBody *ballBody;
SKLabelNode *scoreLabel[2];
CFTimeInterval previousTime = 0;
BOOL upArrowPressed[2];
BOOL downArrowPressed[2];
int score[2] = {0, 0};

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    
    
    /* Background setup */
    [self setBackgroundColor:[NSColor blackColor]];
    
    /* Border setup */
    SKShapeNode *bottomBorder = [SKShapeNode shapeNodeWithRect:CGRectMake(PADDING, PADDING, self.size.width - PADDING * 2, BORDER_HEIGHT)];
    SKShapeNode *topBorder = [SKShapeNode shapeNodeWithRect:CGRectMake(PADDING, self.size.height - PADDING - BORDER_HEIGHT, self.size.width - PADDING * 2, BORDER_HEIGHT)];
    
    bottomBorder.fillColor = [NSColor whiteColor];
    topBorder.fillColor = [NSColor whiteColor];
    
    [self addChild:bottomBorder];
    [self addChild:topBorder];
    
    /* Divider setup */
    CGMutablePathRef dividerPath = CGPathCreateMutable();
    CGPathMoveToPoint(dividerPath, NULL, self.size.width / 2, self.size.height - PADDING - BORDER_HEIGHT);
    CGPathAddLineToPoint(dividerPath, NULL, self.size.width / 2, PADDING + BORDER_HEIGHT);
    
    CGFloat pattern[2] = {DIVIDER_SPACE, DIVIDER_SPACE};
    CGPathRef dashedDividerPath = CGPathCreateCopyByDashingPath(dividerPath, NULL, 0, pattern, 2);
    SKShapeNode *dashedDivider = [SKShapeNode shapeNodeWithPath:dashedDividerPath];
    dashedDivider.lineWidth = DIVIDER_WIDTH;
    
    [self addChild:dashedDivider];
    
    /* Paddle setup */
    paddle[0] = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(PADDLE_WIDTH, PADDLE_HEIGHT)];
    paddle[1] = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(PADDLE_WIDTH, PADDLE_HEIGHT)];
    
    paddle[0].position = CGPointMake(PADDING + PADDLE_WIDTH / 2, self.size.height / 2);
    paddle[1].position = CGPointMake(self.size.width - PADDING - PADDLE_WIDTH / 2, self.size.height / 2);
    
    paddle[0].fillColor = [NSColor whiteColor];
    paddle[1].fillColor = [NSColor whiteColor];
    
    [self addChild:paddle[0]];
    [self addChild:paddle[1]];
    
    /* Ball setup */
    ball = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(BALL_SIZE, BALL_SIZE)];
    ball.position = CGPointMake(self.size.width / 4, self.size.height / 2);
    ball.fillColor = [NSColor whiteColor];
    
    ballBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(BALL_SIZE, BALL_SIZE)];
    ballBody.affectedByGravity = false;
    ballBody.allowsRotation = false;
    ballBody.velocity = CGVectorMake(BALL_SPEED, BALL_SPEED);
    ball.physicsBody = ballBody;
    
    [self addChild:ball];
    
    /* Score label setup */
    scoreLabel[0] = [SKLabelNode labelNodeWithText:@"0"];
    scoreLabel[1] = [SKLabelNode labelNodeWithText:@"0"];
    
    scoreLabel[0].fontName = @"Menlo-Regular";
    scoreLabel[1].fontName = @"Menlo-Regular";
    
    scoreLabel[0].fontColor = [NSColor whiteColor];
    scoreLabel[1].fontColor = [NSColor whiteColor];
    
    scoreLabel[0].position = CGPointMake(self.size.width / 2 - PADDING * 3, self.size.height - PADDING * 3 - BORDER_HEIGHT);
    scoreLabel[1].position = CGPointMake(self.size.width / 2 + PADDING * 3, self.size.height - PADDING * 3 - BORDER_HEIGHT);
    
    [self addChild:scoreLabel[0]];
    [self addChild:scoreLabel[1]];
}

-(void)keyDown:(NSEvent *)theEvent {
    switch (theEvent.keyCode) {
        case 126:
            upArrowPressed[1] = true;
            break;
            
        case 125:
            downArrowPressed[1] = true;
            break;
            
        case 13:
            upArrowPressed[0] = true;
            break;
            
        case 1:
            downArrowPressed[0] = true;
            break;
            
        default:
            break;
    }
}

-(void)keyUp:(NSEvent *)theEvent {
    switch (theEvent.keyCode) {
        case 126:
            upArrowPressed[1] = false;
            break;
            
        case 125:
            downArrowPressed[1] = false;
            break;
            
        case 13:
            upArrowPressed[0] = false;
            break;
            
        case 1:
            downArrowPressed[0] = false;
            break;
            
        default:
            break;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (upArrowPressed[0] && paddle[0].position.y < self.size.height - PADDING - BORDER_HEIGHT - PADDLE_HEIGHT / 2) {
        paddle[0].position = CGPointMake(paddle[0].position.x, paddle[0].position.y + (currentTime - previousTime) * PADDLE_SPEED);
    } else if (downArrowPressed[0] && paddle[0].position.y > PADDING + BORDER_HEIGHT + PADDLE_HEIGHT / 2) {
        paddle[0].position = CGPointMake(paddle[0].position.x, paddle[0].position.y - (currentTime - previousTime) * PADDLE_SPEED);
    }
    
    if (upArrowPressed[1] && paddle[1].position.y < self.size.height - PADDING - BORDER_HEIGHT - PADDLE_HEIGHT / 2) {
        paddle[1].position = CGPointMake(paddle[1].position.x, paddle[1].position.y + (currentTime - previousTime) * PADDLE_SPEED);
    } else if (downArrowPressed[1] && paddle[1].position.y > PADDING + BORDER_HEIGHT + PADDLE_HEIGHT / 2) {
        paddle[1].position = CGPointMake(paddle[1].position.x, paddle[1].position.y - (currentTime - previousTime) * PADDLE_SPEED);
    }
    
    if (ball.position.y >= self.size.height - PADDING - BORDER_HEIGHT) {
        ballBody.velocity = CGVectorMake(ballBody.velocity.dx, -1 * BALL_SPEED);
    } else if (ball.position.y <= PADDING + BORDER_HEIGHT) {
        ballBody.velocity = CGVectorMake(ballBody.velocity.dx, BALL_SPEED);
    }
    
    if (ball.position.x >= self.size.width - PADDING - PADDLE_WIDTH - BALL_SIZE / 2) {
        if  (fabs(ball.position.y - paddle[1].position.y) <= PADDLE_HEIGHT / 2 + BALL_SIZE) {
            ballBody.velocity = CGVectorMake(-1 * BALL_SPEED, ballBody.velocity.dy);
        } else {
            [self incrementScore:0];
        }
    } else if (ball.position.x <= PADDING + PADDLE_WIDTH + BALL_SIZE / 2) {
        if (fabs(ball.position.y - paddle[0].position.y) <= PADDLE_HEIGHT / 2 + BALL_SIZE) {
            ballBody.velocity = CGVectorMake(BALL_SPEED, ballBody.velocity.dy);
        } else {
            [self incrementScore:1];
        }
    }
    
    previousTime = currentTime;
}

-(void) incrementScore:(int)player {
    if (player == 0 || player == 1) {
        score[player] += 1;
        ball.position = CGPointMake(self.size.width / 4, self.size.height / 2);
        ballBody.velocity = CGVectorMake(BALL_SPEED, BALL_SPEED);
        scoreLabel[player].text = [NSString stringWithFormat:@"%d", score[player]];
    }
}

@end
