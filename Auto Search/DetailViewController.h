//
//  DetailViewController.h
//  Auto Search
//
//  Created by NIRAV on 7/20/14.
//  Copyright (c) 2014 NIRAV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (assign, nonatomic) id detailItem;

@property (assign, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
