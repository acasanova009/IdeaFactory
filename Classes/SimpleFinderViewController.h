//
//  SimpleFinderViewController.h
//  IdeaFactory
//
//  Created by Alfonso on 2/3/14.
//  Copyright (c) 2014 Renato Casanova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinderControllerProtocols.h"
#import "NewArchiveController.h"
#import "ConceptController.h"
@interface SimpleFinderViewController : UITableViewController <NewArchiveProtocol,ConceptsNavigationProtocol>

@property (nonatomic)NSMutableArray * rootKeys;

@property (nonatomic,assign) id <FinderArchiveReferenceProtocol> referenceDelegate;

-(IBAction)cancelConceptSegue:(UIStoryboardSegue*)sender;
@end
