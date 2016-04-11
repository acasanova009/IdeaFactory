//
//  SimpleFinderViewController.m
//  IdeaFactory
//
//  Created by Alfonso on 2/3/14.
//  Copyright (c) 2014 Renato Casanova. All rights reserved.
//

#import "SimpleFinderViewController.h"
#import "BWFileManagementAdditions.h"
#import "URLConst.h"
#import "NewArchiveController.h"
#import "AlertStrings.h"

@interface SimpleFinderViewController ()

{
    
    NSIndexPath *selectedRow;
}
@end

@implementation SimpleFinderViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self updateReferences];
}
- (void )updateReferences
{

    
    NSURL* path = [[NSURL URLsetUpFrom:urlLibaryPreferences]URLByAppendingPathComponent:kListNames];
    
    self.rootKeys = [NSMutableArray arrayWithContentsOfURL:path];
    if (!self.rootKeys) {
        self.rootKeys = [NSMutableArray array];
        [self.rootKeys writeToURL:path atomically:YES];
    }
    
    [[NSFileManager defaultManager] updateRootKeysReferences:self.rootKeys shouldAnimateRows:self.tableView AndDelegate:self.referenceDelegate];

    if (self.rootKeys) {
        [self.rootKeys writeToURL:path atomically:YES];
    }
    
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

    return self.rootKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 
    
//OLDNAVY
    cell.textLabel.text = self.rootKeys[indexPath.item][1];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



#pragma mark - NewArchive
-(BOOL)wantsToCreateNewArchive:(NSString *)archiveName isList:(BOOL)isList
{
//OLDNAVY
    for (NSArray *letras in self.rootKeys) {
        if ([archiveName isEqualToString:[letras[1] stringByDeletingPathExtension]]) {
            return NO;
        }
    }
    NSURL * urlM =[NSURL URLsetUpFrom:urlDocuments] ;
    [kEmptyText writeToURL:[urlM URLByAppendingPathComponent:[archiveName stringByAppendingPathExtension:kTextSuffix]] atomically:YES encoding:NSUTF8StringEncoding error:nil];
   

    if (self.presentedViewController)
        [self dismissViewControllerAnimated:YES completion:^{
        [self updateReferences];}];
//
    
    return YES;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    if ([segue.identifier isEqualToString:@"newArchiveSegue"]) {
        NewArchiveController * newa = [segue destinationViewController];
        [newa setDelegate:self];
        
    }
}
-(void)cancelConceptSegue:(UIStoryboardSegue *)sender
{}

//OLDNAVY
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* kind = self.rootKeys[indexPath.row] ;
    
            NSURL * urlM =[NSURL URLsetUpFrom:urlDocuments] ;
            
            ConceptController* conceptController = (ConceptController*) [self.storyboard instantiateViewControllerWithIdentifier:@"conceptsController"];
            NSArray *contents = [[NSFileManager defaultManager]parseTextFileAt:[urlM URLByAppendingPathComponent:kind[1]]];
            [conceptController setDelegate:self];
            [conceptController defineTitleOfList:kind[1]  backButton:NSLocalizedString(@"back", @"back button title for adding concepts") andSetListsOfConcepts:contents andAllowEditing:YES];
            
            [self presentViewController:conceptController animated:YES completion:^{}];
    
    selectedRow = indexPath;
    
    
}
//OLDNAVY

-(BOOL)realllocateConceptList:(NSArray *)concepts ofList:(NSString *)oldListName  andChangeItsNameTo:(NSString*)newNameList
{
    if ([self presentedViewController]) {
        
        NSURL * urlM =[NSURL URLsetUpFrom:urlDocuments] ;
        
        NSString * text = [concepts componentsJoinedByString:@"\n"];
        
        if ([oldListName isEqualToString:newNameList]) {
            
            
            
            [text writeToURL:[urlM URLByAppendingPathComponent:oldListName] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            
        }
        else
        {
            if ([self checkForDuplicate:newNameList ])
                return NO;
            
            [[NSFileManager defaultManager]removeItemAtURL:[urlM URLByAppendingPathComponent:oldListName ] error:nil];
            [text writeToURL:[urlM URLByAppendingPathComponent:newNameList] atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
        }
        [self dismissViewControllerAnimated:YES completion:^{
            
            [self performSelector:@selector(deselectRow:) withObject:selectedRow afterDelay:0.2f];
            
        }];
        
            }
    

    
    [self updateReferences];
    return YES;
}
-(void)deselectRow:(NSIndexPath*)indexPath
{
    [self.tableView deselectRowAtIndexPath:selectedRow animated:YES];
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        NSURL * urlM =[NSURL URLsetUpFrom:urlDocuments] ;
        NSArray * kind = self.rootKeys[indexPath.row];
        NSURL *archiveURL = [urlM URLByAppendingPathComponent:kind[1]] ;
        
        NSError *error;
        
        [[NSFileManager defaultManager] removeItemAtURL:archiveURL error:&error];
        if (error) 
            NSLog(@"Error while deleting. %@",error);
        
        [self updateReferences];
        
    }
}
//OLDNAVY
-(BOOL)checkForDuplicate:(NSString *)name
{
    
    for (NSArray *kind in self.rootKeys) {
            if ([kind[1]isEqualToString:name] )
                return YES;
        
    }
    return NO;
    
}
@end
