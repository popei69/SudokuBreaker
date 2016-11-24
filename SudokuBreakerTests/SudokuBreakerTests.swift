//
//  SudokuBreakerTests.swift
//  SudokuBreakerTests
//
//  Created by Benoit PASQUIER on 12/07/2016.
//  Copyright © 2016 Benoit PASQUIER. All rights reserved.
//

import XCTest

class SudokuBreakerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testClearGrid() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var solver = Solver()
        solver.clearAll()
        
        XCTAssert(solver.grid == emptySudoky)
    }
    
    func testPerformanceSolutionGrid() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            
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
            
            let sudokuSolved = [
                [5, 3, 4, 6, 7, 8, 9, 1, 2],
                [6, 7, 2, 1, 9, 5, 3, 4, 8],
                [1, 9, 8, 3, 4, 2, 5, 6, 7],
                [8, 5, 9, 7, 6, 1, 4, 2, 3],
                [4, 2, 6, 8, 5, 3, 7, 9, 1],
                [7, 1, 3, 9, 2, 4, 8, 5, 6],
                [9, 6, 1, 5, 3, 7, 2, 8, 4],
                [2, 8, 7, 4, 1, 9, 6, 3, 5],
                [3, 4, 5, 2, 8, 6, 1, 7, 9]]
            
            
            var solver = Solver(grid: sudokuToSolve)
            
            solver.findSolution()
            
            XCTAssert(solver.solutionGrid == sudokuSolved)
        }
    }
    
}
