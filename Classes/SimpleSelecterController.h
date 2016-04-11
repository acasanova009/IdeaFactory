//
//  SimpleSelecterController.h
//  IdeaFactory
//
//  Created by Alfonso on 2/4/14.
//  Copyright (c) 2014 Renato Casanova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleSelecterController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


-(NSArray*)getPreferedLists;
-(void)applyPreferedLists:(NSArray*)bools;

@end
