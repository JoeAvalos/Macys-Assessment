//
//  ViewController.m
//  AcronymsAssesment
//
//  Created by Joe Avalos on 9/23/15.
//  Copyright (c) 2015 TEST. All rights reserved.
//

#import "ViewController.h"
#import <MBProgressHUD.h>
#import "WebserviceHandler.h"
#import "AcroynymCell.h"

@interface ViewController ()<UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblAcronyms;
@property (strong, nonatomic) NSArray *arrSFLF;

@end

@implementation ViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Searchbar Methods
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if( searchBar.text.length > 1){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"Loading";
        
        [WebserviceHandler getShortFormOrLongFormFor:searchBar.text withCompletion:^(NSArray *arrSFLF, NSError *error) {
            [hud hide:YES];
            if( error){
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:error.description
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil] show];
            }
            else{
                self.arrSFLF = arrSFLF;
                [self.tblAcronyms reloadData];
            }
        }];
    }
    
    [searchBar resignFirstResponder];
}

#pragma mark - Tableview Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrSFLF.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AcroynymCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.lblResult.text = [self.arrSFLF[indexPath.row] strResult];
    cell.lblFreq.text = [NSString stringWithFormat:@"Frequency: %@",[self.arrSFLF[indexPath.row] numFrequency].description];
    cell.lblSince.text = [NSString stringWithFormat:@"Since:%@",[self.arrSFLF[indexPath.row] numSince].description];
    
    return cell;
}

@end
