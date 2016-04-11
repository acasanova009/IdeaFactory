//
//  PremiseController.h
//  Table
//
//  Created by Renato Casanova on 4/24/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <UIKit/UIKit.h>




#import "PremiseCell.h"



#import "BWFileManagementAdditions.h"
#import "SimpleFinderViewController.h"
#import "SimpleSelecterController.h"
#import "InfoController.h"



@interface PremiseController : UIViewController  <PremiseProtocol,UITextFieldDelegate,FinderArchiveReferenceProtocol,InfoProtocol,UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UIBarButtonItem *infoBarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ideaButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *listsButton;
/** outlet for the SHARE idea button **/
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

/** Add premises outlete**/
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

/** Main table view
 *Where premises reside
 */

- (IBAction)selecterButtonAction:(id)sender;


/*Create new idea*/
- (IBAction)idea:(id)sender;
/* Share idea*/
- (IBAction)share:(id)sender;
/** Open Finde */
//- (IBAction)finder:(id)sender;
/* Insert new prmise cell*/
- (IBAction)add:(id)sender;

/*Selecter interaction*/
@property (weak, nonatomic) IBOutlet UIView *selecterContainer;
@property (weak, nonatomic) IBOutlet UIButton *selecterButton;

@property (nonatomic) SimpleSelecterController * selecterController;

/*Big invisible button to hide keyboard*/
//- (IBAction)selecterInvisiblePressed:(id)sender;


/*EXTERNAL interaction*/

-(IBAction)finishedWritingReview:(UIStoryboardSegue*)sender;
-(IBAction)cancelSegue:(UIStoryboardSegue*)sender;
/*EXTERNAL common method**/
-(void)saveData;



@end
