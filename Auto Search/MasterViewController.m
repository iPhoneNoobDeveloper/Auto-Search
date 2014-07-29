//
//  MasterViewController.m
//  Auto Search
//
//  Created by NIRAV on 7/20/14.
//  Copyright (c) 2014 NIRAV. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController
//@synthesize searchArray;
- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   self.title = @"Search";

   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }


    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = _searchArray[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    for (AFHTTPRequestOperation *operationSaved in arrOperations) {
        if([operationSaved isExecuting]){
            [operationSaved cancel];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
   
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (_searchArray ) {
        [_searchArray removeAllObjects];
    }
    else{
        _searchArray = [[NSMutableArray alloc]init];
    }
    [_searchArray removeAllObjects];
    [self.tableView reloadData];
    
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&entity=song" ,  [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", urlString]] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60];
    
    NSLog(@"URL_searchProduct : %@",urlRequest);
    
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"POST"];
   // [urlRequest setHTTPBody:jsonData];
    
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            
            NSDictionary *jsonDict = (NSDictionary *) JSON;
            //                NSBundle *mainBundle = [NSBundle mainBundle];
            //                NSString *myFile = [mainBundle pathForResource: @"subcategories" ofType: @"json"];
            //                NSData *data = [NSData dataWithContentsOfFile:myFile];
            //                NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            //                NSDictionary *jsonDict = [strData JSONValue];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSLog(@"JSON %@", JSON);
            NSArray *arrayResult = [jsonDict objectForKey:@"results"];
            
            for (int i = 0; i < [arrayResult count]; i++) {
                NSDictionary *dictTrackDetail = [arrayResult objectAtIndex:i];
                [_searchArray addObject:[dictTrackDetail objectForKey:@"trackName"]];
            }
            
            [self.searchDisplayController.searchResultsTableView reloadData];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
                    NSError *error, id JSON) {
            
           
            NSLog(@"Request Failure Because %@",[error userInfo]);
        }
        ];
    
    [operation start];
    if (!arrOperations) {
        arrOperations=[[NSMutableArray alloc] init];
        
    }
    [arrOperations addObject:operation];
}

@end
