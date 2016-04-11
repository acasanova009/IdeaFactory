//
//  NewArchiveController.m
//  Table
//
//  Created by Renato Casanova on 5/27/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import "NewArchiveController.h"
#import "AlertStrings.h"

@interface NewArchiveController ()
{
    BOOL isWritingAList;
    BOOL isFolderOnly;
}
@end

@implementation NewArchiveController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.listName becomeFirstResponder];
    [self.listName setDelegate:self];


    isWritingAList = YES;
    [self.TypeTitle setText:NSLocalizedString(@"newList", @"Cuando vas a crear un archivo nuevo")];
    
    if (isFolderOnly) {


        [self.iconButton setUserInteractionEnabled:NO];
        [self.view setNeedsDisplay];
        [self.TypeTitle setText:NSLocalizedString(@"newFolder", @"Cuando vas a crear un folder nuevo")];
    }
}
-(void)setFolderCreation:(BOOL)folderOnly
{
    isFolderOnly =folderOnly;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self createNewList:nil];
    return NO;
}
- (IBAction)createNewList:(id)sender {
    if ([self.listName.text isEqualToString:kEmptyText])

    {
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:
                              NSLocalizedString(@"Empty name.", @"There is no name written") message:
                              NSLocalizedString(@"Write the name of the list and then touch add.", @"Add name of list") delegate:nil cancelButtonTitle:
                              NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wantsToCreateNewArchive:isList:)]) {

        if ([self.delegate wantsToCreateNewArchive:self.listName.text isList:isWritingAList])
        
            self.listName.text = kEmptyText;
        
        
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:
                                  NSLocalizedString(@"Existing Name.", @"The name you want to use, already exists.") message:
                                  NSLocalizedString(@"The name of the desired archive, already exists. Try a different one.", @"Duplicating ARCHIVE") delegate:nil cancelButtonTitle:
                                  NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles:nil];
            [alert show];

        }
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
