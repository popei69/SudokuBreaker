//
//  GridViewController.swift
//  SudokuSolver
//
//  Created by Benoit PASQUIER on 06/07/2016.
//  Copyright © 2016 Benoit PASQUIER. All rights reserved.
//

import UIKit

class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var gridCollectionView: UICollectionView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var solveButton: UIButton!
    
    var grid = [Array<Int>]()
    var solver = Solver()
    
    var cellWidth : CGFloat = 50.0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let sudokuToSolve = [
            [5, 3, 0, 0, 7, 0, 0, 0, 0],
            [6, 0, 0, 1, 9, 5, 0, 0, 0],
            [0, 9, 8, 0, 0, 0, 0, 6, 0],
            [8, 0, 0, 0, 6, 0, 0, 0, 3],
            [4, 0, 0, 8, 0, 3, 0, 0, 1],
            [7, 0, 0, 0, 2, 0, 0, 0, 6],
            [0, 6, 0, 0, 0, 0, 2, 8, 0],
            [0, 0, 0, 4, 1, 9, 0, 0, 5],
            [0, 0, 0, 0, 8, 0, 0, 7, 9]]

        
        self.solver = Solver(grid: sudokuToSolve)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // define a square
        let width : CGFloat = self.view.frame.width - 40
        heightConstraint.constant = width

        cellWidth = (width - (8 * 5)) / 9
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 4
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        gridCollectionView.setCollectionViewLayout(flowLayout, animated: false)
    }
    
    
    @IBAction func solveAction(sender: AnyObject) {
        
        solveButton.enabled = false
        
        // TODO: Dispatch on another thread
        solver.findSolution()
        
        if solver.isResolved {
            print("Success")
            solver.isProcessing = false
            self.grid = solver.solutionGrid
            gridCollectionView.reloadData()
        }
    }
    
    @IBAction func clearAction(sender: AnyObject) {
        
        solver.clearAll()
        self.grid = solver.grid
        gridCollectionView.reloadData()
        solveButton.enabled = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gridCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Collection Delegate & DataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // hardcoded for now
        return 81
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GridCollectionCell", forIndexPath: indexPath) as! GridCollectionCell
        
        if let value = solver.valueAtPosition(indexPath.row) {
            
            if solver.isResolved && value == 0 {
                
                if let solutionValue = solver.solutionValueAtPosition(indexPath.row) {
                    cell.valueLabel.text = "\(solutionValue)"
                    cell.valueLabel.textColor = UIColor.redColor()
                } else {
                    cell.valueLabel.text = "\(value)"
                    cell.valueLabel.textColor = UIColor.blackColor()
                }
            } else {
                cell.valueLabel.text = "\(value)"
                cell.valueLabel.textColor = UIColor.blackColor()
            }
        }
        
        
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
