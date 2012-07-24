//
//  GraphicsFavoritesViewController.h
//  Calculator
//
//  Created by Heiko Goes on 24.07.12.
//  Copyright (c) 2012 my Software Goes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphicsFavoritesViewController;

@protocol GraphicFavoriteSelected <NSObject>
        
- (void) controller: (GraphicsFavoritesViewController *) controller didSelect: (id) program;

@end

@interface GraphicsFavoritesViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *favorites;
@property (nonatomic, weak) id<GraphicFavoriteSelected> selection;

@end
