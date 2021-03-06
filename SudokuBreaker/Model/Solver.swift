//
//  Solver.swift
//  SudokuSolver
//
//  Created by Benoit PASQUIER on 06/07/2016.
//  Copyright © 2016 Benoit PASQUIER. All rights reserved.
//

import Foundation

let emptySudoky = [
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0]]

struct Solver {
    
    var grid = [Array<Int>]()
    
    var solutionGrid = [Array<Int>]()
    var isResolved = false
    var isProcessing = false
    
    init() {
        self.grid = emptySudoky
    }
    
    init(grid: [Array<Int>]) {
        self.grid = grid
    }
    
    fileprivate func printGrid(_ grid: [Array<Int>]) -> Void {
        
        print(" --------------- Start ----------------")
        
        for line in grid {
            
            var fullLine = " | "
            for number in line {
                
                fullLine += " \(number) |"
            }
            
            print(fullLine)
            print(" --------------------------------------")
        }
        
        print(" ---------------- Stop ----------------")
    }
    
    fileprivate func isNumberInGridColumn(_ grid:[Array<Int>], column:Int, valueToSearch:Int) -> Bool {
        
        if grid.count == 0 {
            return false
        }
        
        for line in grid {
            
            if line.count == 0 || column >= line.count {
                return false
            }
            
            if line[column] == valueToSearch {
                return true
            }
        }
        
        return false
    }
    
    fileprivate func isNumberInGridLine(_ grid:[Array<Int>], line:Int, valueToSearch:Int) -> Bool {
        
        if grid.count == 0 || line >= grid.count {
            return false
        }
        
        return grid[line].contains(valueToSearch)
    }
    
    fileprivate func isNumberInSubGrid(_ grid:[Array<Int>], line:Int, column:Int, valueToSearch:Int) -> Bool {
        
        if grid.count == 0 || line >= grid.count || column >= grid[line].count {
            return false
        }
        
        let tmpLine = line - (line % 3)
        let tmpColumn = column - (column % 3)
        
        for l in tmpLine..<tmpLine + 3 {
            
            for c in tmpColumn..<tmpColumn + 3 {
                
                if grid[l][c] == valueToSearch {
                    return true
                }
            }
        }
        
        return false
    }
    
    fileprivate mutating func backtrack(_ grid:[Array<Int>], line:Int, column: Int) -> Bool {
        
        var tmpColumn = column
        var tmpLine = line
        
        if (tmpColumn > 8) {
            tmpColumn = 0
            tmpLine += 1
            
            if (tmpLine > 8) {
                
                print("-- find solution -- out of grid --")
                printGrid(grid)
                self.solutionGrid = grid
                self.isProcessing = false
                self.isResolved = true
                return true
            }
        }
        
        // move to next position if value already filled
        if grid[tmpLine][tmpColumn] != 0 {
            return backtrack(grid, line: tmpLine, column: tmpColumn + 1)
        }
        
        var gridCopy = grid
        
        for tmpValue in 1..<10 {
            
            gridCopy[tmpLine][tmpColumn] = tmpValue
            
            // check for collision
            let isInline = isNumberInGridLine(grid, line: tmpLine, valueToSearch: tmpValue)
            let isIncolumn = isNumberInGridColumn(grid, column: tmpColumn, valueToSearch: tmpValue)
            let isInSubGrid = isNumberInSubGrid(grid, line: tmpLine, column: tmpColumn, valueToSearch: tmpValue)
            
            if (!isInline && !isIncolumn && !isInSubGrid) {
                gridCopy[tmpLine][tmpColumn] = tmpValue
                
                if (backtrack(gridCopy, line: tmpLine, column: tmpColumn + 1)) {
                    return true
                }
            }
        }
        
        print("-- back track from \(tmpLine) \(tmpColumn) -- ")
        gridCopy[tmpLine][tmpColumn] = 0
        return false
    }
    
    mutating func findSolution() {
    
        self.isProcessing = true
        
        self.backtrack(self.grid, line: 0, column: 0)
    }
    
    func valueAtPosition(_ position: Int) -> Int? {
        
        let line = position / 9
        let column = position % 9
        
        if line >= grid.count || column >= grid[line].count {
            return nil
        }
        
        return grid[line][column]
    }
    
    mutating func setValueAtPosition(_ position: Int, newValue: Int) -> Void {
        let line = position / 9
        let column = position % 9
        
        if line >= grid.count || column >= grid[line].count {
            return
        }
        
        grid[line][column] = newValue
    }
    
    func solutionValueAtPosition(_ position: Int) -> Int? {
        
        if (!isResolved) { return nil }
        
        let line = position / 9
        let column = position % 9
        
        if line >= grid.count || column >= grid[line].count {
            return nil
        }
        
        return solutionGrid[line][column]
    }
    
    mutating func clearAll() {
        
        isResolved = false
        isProcessing = false
        
        solutionGrid.removeAll()
        grid = emptySudoky
    }
    
}
