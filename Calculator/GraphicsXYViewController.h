//
//  GraphicsXYViewController.h
//  Calculator
//
//  Created by Heiko Goes on 12.07.12.
//  Copyright (c) 2012 my Software Goes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphicsXYView.h"

@interface GraphicsXYViewController : UIViewController<GraphicsDatasource>

@property (weak, nonatomic) IBOutlet GraphicsXYView *graphicsView;

@end
