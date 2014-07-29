//
//  MasterViewController.h
//  Auto Search
//
//  Created by NIRAV on 7/20/14.
//  Copyright (c) 2014 NIRAV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController{
    AFJSONRequestOperation *operation;
    NSMutableArray *arrOperations;
}
@property (nonatomic, retain) NSMutableArray *searchArray;
@end
