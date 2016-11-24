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
    
    var settingsImageView = UIImageView()
    
    var grid = [Array<Int>]()
    var solver = Solver() // clear
    
    var cellWidth : CGFloat = 50.0
    
    var selectedIndexPath : IndexPath?
    var isGridLocked = false

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

        
//        self.solver = Solver(grid: sudokuToSolve)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // define a square
        let width : CGFloat = self.view.frame.width - 40
//        heightConstraint.constant = width

        cellWidth = (width - (8 * 5)) / 9
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 4
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        gridCollectionView.setCollectionViewLayout(flowLayout, animated: false)
        
        settingsImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35.0, height: 35.0))
    }
    
    
    @IBAction func solveAction(_ sender: AnyObject) {
        
        solveButton.isEnabled = false
        isGridLocked = true;
        
        startAnimation()
        
        // TODO: Dispatch on another thread
        let resolutionQueue = DispatchQueue(label: "solution-queue")
        resolutionQueue.async {
            self.solver.findSolution()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            
            if self.solver.isResolved {
                print("Success")
                self.solver.isProcessing = false
                self.grid = self.solver.solutionGrid
                self.gridCollectionView.reloadData()
            }
        })
    }
    
    @IBAction func clearAction(_ sender: AnyObject) {
        
        solver.clearAll()
        self.grid = solver.grid
        gridCollectionView.reloadData()
        solveButton.isEnabled = true
    }
    
    @IBAction func updateValueAction(_ sender:AnyObject) {
        
        if let selectedIndexPath = selectedIndexPath,
            let button = sender as? UIButton,
            let currentTitle = button.currentTitle,
            let newValue = Int(currentTitle),
            !isGridLocked {
            
            solver.setValueAtPosition(selectedIndexPath.row, newValue: newValue)
            self.gridCollectionView.reloadItems(at: [selectedIndexPath])
        }
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // hardcoded for now
        return 81
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionCell", for: indexPath) as! GridCollectionCell
        
        if let value = solver.valueAtPosition(indexPath.row) {
            
            // if sudoku resolve
            if solver.isResolved {
                
                // get the resolved value
                if let solutionValue = solver.solutionValueAtPosition(indexPath.row), value == 0 {
                    cell.valueLabel.text = "\(solutionValue)"
                    cell.valueLabel.textColor = UIColor.red
                } else {
                    cell.valueLabel.text = "\(value)"
                    cell.valueLabel.textColor = UIColor.black
                }
                
            } else {
                
                if value != 0 {
                    cell.valueLabel.text = "\(value)"
                    cell.valueLabel.textColor = UIColor.black
                } else {
                    cell.valueLabel.text = ""
                }
            }
        }
        
        if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
            cell.valueLabel.layer.borderColor = UIColor.red.cgColor
            cell.valueLabel.layer.borderWidth = 2
        } else {
            cell.backgroundColor = UIColor.white
            cell.valueLabel.layer.borderWidth = 0
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var tmpIndexPaths : [IndexPath] = [indexPath]
        if let oldIndexPath = selectedIndexPath {
            tmpIndexPaths.append(oldIndexPath)
        }
        selectedIndexPath = indexPath
        collectionView.reloadItems(at: tmpIndexPaths)
    }
    
    
    // MARK: - Animation
    
    func startAnimation() {
        
        settingsImageView.image = UIImage(named: "settings")
        settingsImageView.center = self.view.center
        
        self.view.addSubview(settingsImageView)
        
        UIView.animate(withDuration: 2.0, animations: {
            self.settingsImageView.transform = self.settingsImageView.transform.rotated(by: CGFloat(M_PI));
        }, completion: { result in
            self.settingsImageView.removeFromSuperview()
        })
    }
    
    func stopAnimation() {
        
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
