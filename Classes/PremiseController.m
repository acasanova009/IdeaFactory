///
//  PremiseController.m
//  Table
//
//  Created by Renato Casanova on 4/24/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//


#import "PremiseController.h"

#import "URLConst.h"

#import "PremiseCell.h"
#import "AlertStrings.h"
#import "BWColors.h"
#define kSelecterHiddenPosition -160
#define kSelecterListsPosition 160
#define kTotalCellsAllowed 20
#define DEBUGG 1
@interface PremiseController ()

{
    //Lists NagController
    UINavigationController *listNav;
    //FILE Management
    NSURL * factoryURL;
    NSURL * masterURL;
    
    NSMutableDictionary * factoryDictionary;
    NSMutableArray *factoryKeys;
    //FIlE right Label
    NSMutableArray *rightFactoryKeys;

    //Cancel and Info Buttons references.
    UIBarButtonItem *cancelBarButton;

    //Main TableView and PhantomCells
    NSMutableArray *phantomCellsArray;
    UITableView * premiseTable;

    //ChecksForActiveCells
    BOOL isThereAnActiveCell;
    NSIndexPath* activeCell;
    NSIndexPath* lastActiveCell;
    //EndForCurrentACtive

    BOOL isMakingANewCell;

    NSNumber * preference;
    NSURL * prefURL;
    
   

    
}

@end

@implementation PremiseController
#pragma mark  Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"simpleFinderControllerSegue"]) {

        SimpleFinderViewController* lists = [segue destinationViewController];

        [lists setReferenceDelegate:self];
    }

    if ([segue.identifier isEqualToString:@"infoSegue"]) {
        InfoController * infoC = [segue destinationViewController];
        [infoC setDelegate:self];
    }


}

#pragma mark - Internal Usage
/*a1*/
-(void)cancelSegue:(UIStoryboardSegue *)sender
{
}
/*a3*/
-(void)saveData
{
    //Llamado cuando la aplcacion va a perder control o va a ser terminada.

    [[NSFileManager defaultManager] saveData:preference        ToURL:prefURL];
    [[NSFileManager defaultManager] saveData:factoryDictionary ToURL:[factoryURL URLByAppendingPathComponent:filePremisesArch]];
    [[NSFileManager defaultManager] saveData:factoryKeys       ToURL:[factoryURL URLByAppendingPathComponent:filePremisesKeys      ]];
    [[NSFileManager defaultManager] saveData:rightFactoryKeys  ToURL:[factoryURL URLByAppendingPathComponent:fileRightLabelKeys ]];

}
#pragma mark - Rate Me
/* Preference file for storing number of pressings*/
/*a4*/
-(void)pragmatisim
{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    prefURL = [[NSURL URLsetUpFrom:urlLibaryPreferences]URLByAppendingPathComponent:filePreferences];
    preference = [fileManager readDataOfClass:[NSNumber class] FromURL:prefURL];
    if (!preference) {
        preference = @0;
        [fileManager saveData:preference ToURL:prefURL];
       [fileManager resetLocalizedFactory];
        [fileManager resetLocalizedDataBase];
        [self reloadAllKeys];
    }
    
}
/*a3*/
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * theUrl = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id={YOUR APP ID}&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theUrl]];
}
/*a4*/
-(void)addValueToPragmatisim
{
    
    preference = [NSNumber numberWithInt:[preference integerValue]+1];
    if ([preference integerValue] == 500) {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"500!"
                                                      message:NSLocalizedString(@"Apparently, you like the app 500 hundres times.", @"Maybe just maybe, you did like the app! Wanna rate me?")
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"cancel", @"Negate the current desivice action")
                                            otherButtonTitles:NSLocalizedString(@"Yeah!", @"Confirmation button to review the app"),nil];
        [aler show];
    }
    if ([preference integerValue] == 1000) {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"1000!"
                                                      message:NSLocalizedString(@"Quite amusing, you have tried for a thousand times to get a new story", @"Maybe just maybe, you did like the app! I wanna rate this!")
                                                     delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"Cancel", @"Negate the current action")
                                            otherButtonTitles:NSLocalizedString(@"Yeah!", @"Confirmation button to review the app"),nil];
        [aler show];
    }


}
#pragma mark - Load


- (void)viewDidLoad
{
    [super viewDidLoad];
    /**Prepares Plist for Rate Me*/
    [self pragmatisim];
    

    /*Loads Edit button from code*/
    UIBarButtonItem *editButton = self.editButtonItem;
    [editButton setTarget:self];
    [editButton setAction:@selector(toggleEdit)];
    self.navigationItem.rightBarButtonItem = editButton;


    /*Loads CAncel button from code*/

    cancelBarButton = [[UIBarButtonItem alloc]init];
    cancelBarButton.title = NSLocalizedString(@"Cancel", @"Negate the current action");
    cancelBarButton.target = self;
    [cancelBarButton setAction:@selector(toggleCancel)];
    cancelBarButton.tintColor = rgb(168, 12, 5);


    

    
    //Lugat donde preparar los archivos y/o crearlos
    [self URLsetUp];
    //Cosas iniciales de la tableView de Premise
    [self premiseTableViewSetUp];


    activeCell = [[NSIndexPath alloc]init];
    lastActiveCell = [[NSIndexPath alloc]init];
    phantomCellsArray = [NSMutableArray array];
    isMakingANewCell = NO;

    //enlace para el selecterView
    self.selecterController = [self.childViewControllers lastObject];


}
-(void)URLsetUp
{
    //URL diecta a nuestas listas.
    factoryURL = [NSURL URLsetUpFrom:urlLibaryFactory];


    //Agrega información o crea desde cero
    factoryDictionary =  [[NSFileManager defaultManager] readDataOfClass:[NSMutableDictionary class] FromURL:[factoryURL URLByAppendingPathComponent:filePremisesArch]];
    
    rightFactoryKeys =   [[NSFileManager defaultManager] readDataOfClass:[NSMutableArray      class] FromURL:[factoryURL URLByAppendingPathComponent:fileRightLabelKeys ]];
    factoryKeys =        [[NSFileManager defaultManager] readDataOfClass:[NSMutableArray      class] FromURL:[factoryURL URLByAppendingPathComponent:filePremisesKeys      ]];
    
}
-(void)premiseTableViewSetUp
{
    //Cosas iniciales de la tableView
    premiseTable = (id)[self.view viewWithTag:1];
    [premiseTable registerClass:[PremiseCell class] forCellReuseIdentifier:@"premiseCell"];

    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - Outlet Actions

- (IBAction)idea:(id)sender {

    [self addValueToPragmatisim];

    for (PremiseCell * cell in [premiseTable visibleCells]) {
        if (cell.currentState == premiseRandomizer) {
            return;
        }
    }
    if (factoryKeys.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                              NSLocalizedString(@"Empty premises", @"When there are no premises") message:
                              NSLocalizedString(@"Generate Idea but there are no premises", @"For this to work, you have add one premise. Touch the plus button to create a new one.") delegate:nil cancelButtonTitle:
                              NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles:   nil];
        [alert show];
    }
    for (int i = 0 ; i < factoryKeys.count; i++) {

        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [self randomizeWordsAtIndexPath:indexPath];

    }
}
- (IBAction)share:(id)sender {

    NSArray *cells = [premiseTable visibleCells];
    NSMutableArray* listsOfWords = [NSMutableArray array];
    [listsOfWords addObject:
     NSLocalizedString(@"Tell me a story with this:", @"Used for sharing with people through (i.e. fb, msg, twitter)")];
    for (PremiseCell* cell in cells) {

        NSString * left = cell.leftLabel.text;

        NSString *right = cell.rightLabel.text;
        if ([right isEqualToString:
             NSLocalizedString(@"Empty lists", @"Returned word when the lists are empty.")] || [right isEqualToString:
                                                                                               NSLocalizedString(@"Select a list", @"Returned word when no there are no selected list in the premise cell")])
            continue;

        NSString* str = [[left stringByAppendingString:@": "] stringByAppendingString:right];
        [listsOfWords addObject:str];
    }
    UIActivityViewController * viewC = [[UIActivityViewController alloc]initWithActivityItems:listsOfWords applicationActivities:nil];
    [self presentViewController:viewC animated:YES completion:nil];
    
    
}



- (IBAction)add:(id)sender {
    if (premiseTable.editing == YES) {
        [self toggleEdit];

    }
    if (factoryKeys.count <kTotalCellsAllowed) {



        NSIndexPath * path = [NSIndexPath  indexPathForItem:0 inSection:0];
        if (factoryKeys.count >1)
            [premiseTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];


        [factoryKeys insertObject:kEmptyText atIndex:path.item];
        [rightFactoryKeys insertObject:NSLocalizedString(@"Select a list", @"Default word for when a new premise is created") atIndex:path.item];
        NSURL* url = [[NSURL URLsetUpFrom:urlLibaryPreferences]URLByAppendingPathComponent:kListNames];
        
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfURL:url];
        
        
        [factoryDictionary setValue:arr forKey:factoryKeys[path.item]];
        [premiseTable insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
    

        isMakingANewCell =YES;
        [self makeCellChangeToState:premiseIdea atPath:path];
    }    
}


#pragma mark - Private Actions
-(void)showCancel:(BOOL)becomeActive
{
    if (becomeActive) {
        self.navigationItem.leftBarButtonItem = cancelBarButton;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = _infoBarButton;
    }

}
-(void)reloadAllKeys
{

    [self URLsetUp];
    [premiseTable reloadData];
}

- (void)toggleCancel {
    if (isMakingANewCell)

        [self makeCellChangeToState:premiseDelete atPath:activeCell];


    else
        [self makeCellChangeToState:premiseCancel atPath:activeCell];

}

- (IBAction)selecterButtonAction:(id)sender {
    
    PremiseCell * cell = (id)[premiseTable cellForRowAtIndexPath:activeCell];
    [cell.leftText resignFirstResponder];
    [self selecterButtonShow:NO];
}

#define No !
- (IBAction)toggleEdit {

    
    if (factoryKeys.count == 0 && premiseTable.editing == NO)
        return;

    for (PremiseCell * cell in [premiseTable visibleCells]) {
    if (cell.currentState == premiseRandomizer)
        return;
    }

//    Initially it starts with no editing;
    BOOL isEditing = premiseTable.editing;
    
    [premiseTable setEditing:(No isEditing) animated:YES];
    self.navigationItem.leftBarButtonItem.enabled = isEditing;

    
    [self enableBottomMenu:isEditing];
    
    if (!isEditing) {
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Done", @"Done");
        //Added in the edition for this button has the same color of the UIBarButtonSystemItemDone
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;
    }
    else{
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
        //Added in the edition for this button has the same color of the UIBarButtonSystemItemDone
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
    }

}
- (void)randomizeWordsAtIndexPath:(NSIndexPath *)indexPath
{


    NSMutableArray *boolList = factoryDictionary[factoryKeys[indexPath.row]];
    NSMutableArray *arry =  [[NSFileManager defaultManager] parseAllTextFilesAtUrlForBools:boolList];



    PremiseCell *premCell = (PremiseCell*)[premiseTable cellForRowAtIndexPath:indexPath];
    int randomW = 0;

    NSString *randomWordToSend;
    if (arry == nil) {
        randomWordToSend =
        NSLocalizedString(@"Select a list", @"Returned word when no there are no selected list in the premise cell");
        
    }
    else  if (arry.count ==0) {

        randomWordToSend =
        NSLocalizedString(@"Empty lists", @"Retunred word when the lists ARE empty");
    }
    else
    {

        randomW = arc4random() %  arry.count;

        randomWordToSend = arry[randomW];
    
    }
    [premCell randomize:randomWordToSend];
    [rightFactoryKeys replaceObjectAtIndex:indexPath.row withObject:randomWordToSend];
}






#pragma mark - TableView Delegate
//WARNING
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [factoryDictionary removeObjectForKey:factoryKeys[indexPath.row]];
    [factoryKeys removeObjectAtIndex:indexPath.row];
    [rightFactoryKeys removeObjectAtIndex:indexPath.row];
    
    PremiseCell* pre = (PremiseCell*)[tableView cellForRowAtIndexPath:indexPath];
    [pre setEditing:NO animated:NO];
    
    
    [premiseTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    if (factoryKeys.count==0 )
    {
        [self enableBottomMenu:YES];
        [self toggleEdit];
    }

    [self saveData];
}
//WARNING
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //Si es mayor al total de premise Cell, se van a crear unas "fantasma" para que se pueda editar el texto de el premise Cell
    if (factoryKeys.count>indexPath.row) {


        PremiseCell *cell = [[PremiseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"premiseCell"];
//        PremiseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"premiseCell" forIndexPath:indexPath];
        
        //Cricual enlazar estos dos protocols a, se otra manera no "sabra" que ourre con este premise cell
        [cell setDelegate:self];
        [cell.leftText setDelegate:self];

        cell.rightLabel.text = rightFactoryKeys[indexPath.row];
        NSString* str = factoryKeys[indexPath.row];
        cell.leftLabel.text = str;


        //Mientra el texto de la celda NO sea un espacio, siginifica que tiene que presentarse
        if (![str isEqualToString:kEmptyText] )
            [cell changePremiseCellStateTo:premisePresentation];

        NSLog(@"Cell des: %@",[cell description]);
        return cell;
    }
    else
    {
        //celda fantasma
        UITableViewCell *phatnomCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"phantomCell"];
        phatnomCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        phatnomCell.textLabel.text = @"Something";
        phatnomCell.backgroundColor = [UIColor clearColor];
        return phatnomCell;

    }
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL allowEdit = NO;
    if (factoryKeys.count>indexPath.row)
        allowEdit = YES;
        return allowEdit;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{return 50;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return (factoryKeys.count + phantomCellsArray.count);}
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{return YES;}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    id object = factoryKeys[sourceIndexPath.row];
    [factoryKeys removeObjectAtIndex:sourceIndexPath.row];
    [factoryKeys insertObject:object atIndex:destinationIndexPath.row];
    

}
#pragma mark - Lists Delegate Translation
#pragma mark - Lists Delegate
-(void)finderControllerWantsToCreateNewArchiveReference:(NSString*)reference
{
    
    int laps = [factoryKeys count];
    for (int i = 0; i < laps; i++) {
    NSMutableArray * bools = [NSMutableArray arrayWithArray: factoryDictionary[factoryKeys[i]]];
    
    [bools insertObject:@[[NSNumber numberWithBool:NO],reference] atIndex:0];
    factoryDictionary[factoryKeys[i]] = bools;
    }
    
    
}
-(void)finderControllerWantsToDeleteArchiveReferences:(NSArray *)toDeleteIndexPaths
{
    int laps = [factoryKeys count];
    for (int i = 0; i < laps; i++) {
        NSMutableArray * bools = [NSMutableArray arrayWithArray: factoryDictionary[factoryKeys[i]]];
        
        
        NSMutableArray *toDelete = [NSMutableArray array];
        for (int  i = 0;  i < toDeleteIndexPaths.count ; i++) {
            NSIndexPath * path = [toDeleteIndexPaths objectAtIndex:i];
            id kindToDelete = [bools objectAtIndex:path.row];
            [toDelete addObject:kindToDelete];
        }
        [bools removeObjectsInArray:toDelete];
        
        factoryDictionary[factoryKeys[i]] = bools;
    }
    
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (premiseTable.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}
#pragma mark - Premise Cell Delegate
-(void)wantsToRandomizeTextAtIndex:(NSIndexPath *)indexPath
{

    [self addValueToPragmatisim];
    [self randomizeWordsAtIndexPath:indexPath];
    

    
    
}
-(void)controllerShouldEnable:(BOOL)enable
{

}
-(void)willDeleteCellAtIndexPath:(NSIndexPath *)indexPath
{

    [factoryDictionary removeObjectForKey:factoryKeys[indexPath.row]];
    [factoryKeys removeObjectAtIndex:indexPath.row];
    [rightFactoryKeys removeObjectAtIndex:indexPath.row];
    [premiseTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    if (factoryKeys.count==0 )
    {
        [self toggleEdit];
    }
}

-(void)shouldChangeToEditingStateCellAtIndex:(NSIndexPath*)indexPath
{
    if (!isThereAnActiveCell)
    [self makeCellChangeToState:premiseIdea atPath:indexPath];
    
}
-(void)shouldChangeToPresentationStateCellAtIndex:(NSIndexPath*)indexPath
{



    PremiseCell * cell = (PremiseCell*)[premiseTable cellForRowAtIndexPath:activeCell];
    NSString * cellName = cell.leftText.text;

    //Si el texto no cambió, continua.
    if (![cellName isEqualToString:cell.leftLabel.text]) {
        //Revisar si ya existe
        if ([cellName isEqualToString:kEmptyText])  {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                                  NSLocalizedString(@"Empty name.", @"There is no name written") message:
                                  NSLocalizedString(@"To save a premise, \n write the name of it.", @"When the user is stuck because he didnt write the name of the premise") delegate:nil cancelButtonTitle:
                                  NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles: nil];

            [alert show];
            [cell.leftText becomeFirstResponder];
            return;
        }
        for (NSString* str in factoryKeys) {

            if ([cellName isEqualToString:str]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:
                                      NSLocalizedString(@"Existing Name.", @"The name you want to use, already exists.") message:
                                      NSLocalizedString(@"You already have a premise with such name, try a different one.", @"Duplicate of premise name") delegate:nil    cancelButtonTitle:
                                      NSLocalizedString(@"All right.", @"Used text for dismissing a presented alert view. As Ok") otherButtonTitles: nil];
                [alert show];
                [cell.leftText becomeFirstResponder];
                return;
            }
        }
        
    }
    [self makeCellChangeToState:premisePresentation atPath:activeCell];

    [self saveData];
    



}



#pragma mark Cell Keyboard Delegate
//Cuando se incia la edicion del text de premice CEll
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

    [self selecterButtonShow:YES];

}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    PremiseCell * cell = (id)[premiseTable cellForRowAtIndexPath:activeCell];
    [cell.leftText resignFirstResponder];
    [self selecterButtonShow:NO];
    return NO;
}



#pragma mark - Active Cell
-(void)removeIfNeededPhantomCellsOfTableView:(UITableView *)tableView
{
    if (phantomCellsArray.count != 0) {

        int removeTotalCells = [phantomCellsArray count];

        for (int i = 0; i <removeTotalCells; i++) {
            NSIndexPath*indexForRows = [NSIndexPath indexPathForItem:(factoryKeys.count) inSection:0];

            [phantomCellsArray removeObjectAtIndex:0];
            [premiseTable deleteRowsAtIndexPaths:@[indexForRows] withRowAnimation:UITableViewRowAnimationFade];

        }
    }
}
- (void)insertIfNeededPhantomCellsAt:(NSIndexPath *)indexPath AtTableView:(UITableView *)tableView
{
    int hiddenCells = factoryKeys.count - 10;//[tableView visibleCells].count;
    int numberOfCellsToInsert = indexPath.row -hiddenCells;

    if (indexPath.row > hiddenCells) {

        for (int i = 0 ; i <numberOfCellsToInsert; i++) {

            [phantomCellsArray addObject:@"phatomCell"];
            NSIndexPath*indexForRows = [NSIndexPath indexPathForItem:(factoryKeys.count+i) inSection:0];
            [premiseTable insertRowsAtIndexPaths:@[indexForRows] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    [premiseTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

}


-(void)selecterContainerShow:(BOOL)show
{
    float speedOfAnimation = 0.7;
    int position =800;
    if (show)
    {
        position = 210;
        speedOfAnimation =0.4; 
    }
    [UIView animateWithDuration:speedOfAnimation animations:^{
        [self.selecterContainer setCenter:CGPointMake(self.selecterContainer.center.x, position)];}];

}


-(void)selecterButtonShow:(BOOL)show
{  int position =kSelecterHiddenPosition;
    if (show)
        position = kSelecterListsPosition;
    [self.selecterButton setCenter:CGPointMake(position, self.selecterContainer.center.y)];
}
-(void)enableBottomMenu:(BOOL)enable
{
    [self.ideaButton setEnabled:enable];
    [self.addButton setEnabled:enable];
    [self.listsButton setEnabled:enable];
    [self.shareButton setEnabled:enable];
}

-(IBAction)finishedWritingReview:(UIStoryboardSegue*)sender
{
    
}
#pragma mark 
-(void)makeCellChangeToState:(enum premiseState)state atPath:(NSIndexPath*)indexPath
{



    PremiseCell*cell = (id)[premiseTable cellForRowAtIndexPath:indexPath];
    if (!(cell && [cell respondsToSelector:@selector(changePremiseCellStateTo:)]))
        return;


    [cell changePremiseCellStateTo:state];

    BOOL active = NO;
    if (state == premiseIdea) {
        active = YES;
    }
    if (!active)
    {
        isMakingANewCell = NO;

        [self removeIfNeededPhantomCellsOfTableView:premiseTable];
        lastActiveCell = activeCell;

    }
    self.navigationItem.rightBarButtonItem.enabled = !active;
    [cell setCellIsActive:active];
    [self showCancel:active];
    [self selecterContainerShow:active];
    [self selecterButtonShow:active];
    [self enableBottomMenu:!active];
    [premiseTable setScrollEnabled:!active];


    switch (state) {

        case premiseIdea:
            [self insertIfNeededPhantomCellsAt:indexPath AtTableView:premiseTable];
            [self.selecterController applyPreferedLists:factoryDictionary[factoryKeys[indexPath.row]]];


            break;
        case premisePresentation:

            factoryDictionary[factoryKeys[indexPath.row]] = [self.selecterController getPreferedLists];

            if (!([factoryKeys[indexPath.row] isEqualToString:cell.leftLabel.text])) {
                [factoryDictionary exchangeOldKey:factoryKeys[indexPath.row] WithNewKey:cell.leftLabel.text];
                factoryKeys[indexPath.row] = cell.leftLabel.text;
            }
            break;

           
        default:
            break;
    }
   
    isThereAnActiveCell = active;
    activeCell = indexPath;
    
    
}

@end
