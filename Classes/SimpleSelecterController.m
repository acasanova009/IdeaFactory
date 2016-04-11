//
//  SimpleSelecterController.m
//  IdeaFactory
//
//  Created by Alfonso on 2/4/14.
//  Copyright (c) 2014 Renato Casanova. All rights reserved.
//

#import "SimpleSelecterController.h"
#import "URLConst.h"
#import "BWFileManagementAdditions.h"
@interface SimpleSelecterController ()
{
    
    BOOL sholdReturnUntouchedLists;
    NSArray * originalBools;
    NSMutableArray * editedBools;
}
@end

@implementation SimpleSelecterController


- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{


    return editedBools.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"simpleSelecterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//OLDNAVY
    id data = editedBools[indexPath.item];
    cell.selected =[data[0] boolValue];
    if (cell.selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
        
    cell.textLabel.text = data[1];

    
    
    return cell;
}
-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    sholdReturnUntouchedLists =NO;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSMutableArray*kind;
    kind =[NSMutableArray arrayWithArray: editedBools[indexPath.row]];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//OLDNAVY
        
        
        [kind replaceObjectAtIndex:0 withObject:@1];
    
        
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        
        [kind replaceObjectAtIndex:0 withObject:@0];
        
    }
    
    [editedBools replaceObjectAtIndex:indexPath.row withObject:kind];
    NSLog(@"hey");
}

-(void)applyPreferedLists:(NSArray*)bools
{
    
    
    originalBools = bools;
    sholdReturnUntouchedLists = YES;
    editedBools = [NSMutableArray arrayWithArray:bools];
    
    [self.tableView reloadData];
    

}
-(NSArray *)getPreferedLists
{
    if (sholdReturnUntouchedLists)
    return originalBools;
    
    return [editedBools copy];
}
@end
