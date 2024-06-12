//
//  BoardTests.swift
//  LoopoverUITests
//
//  Created by Tyler McCormick on 6/10/24.
//

import XCTest

@testable import Loopover

final class BoardTests: XCTestCase {

    func testCreateBoard() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let board = Board(5, 5)
        
        XCTAssertEqual(board.rows, 5)
        XCTAssertEqual(board.cols, 5)
    }
    
    func testBoardResize() {
        let board = Board(5, 5)
        
        board.resize(6)
        XCTAssertEqual(board.rows, 6)
        XCTAssertEqual(board.cols, 6)
    }
    
    func testMoveColRight() {
        let board = Board(5, 5)
        
        // [A, B, C, D, E] -> [E, A, B, C, D]
        let move = Move(axis: .Col, index: 0, n: 1)
        board.move(move)
        
        XCTAssertEqual(board.board[0].compactMap { $0.num }, [4, 0, 1, 2, 3])
        XCTAssertEqual(board.board[1].compactMap { $0.num }, [5, 6, 7, 8, 9])
    }
    
    func testMoveColLeft() {
        let board = Board(5, 5)
        
        // [0, 1, 2, 3, 4] -> [1, 2, 3, 4, 0]
        let move = Move(axis: .Col, index: 0, n: -1)
        board.move(move)
        
        XCTAssertEqual(board.board[0].compactMap { $0.num }, [1, 2, 3, 4, 0])
    }

    func testMoveRowUp() {
        let board = Board(5, 5)
        
        
        let move = Move(axis: .Row, index: 0, n: -1)
        board.move(move)
        
        XCTAssertEqual(board.board[0][0].num, 5)
        XCTAssertEqual(board.board[1][0].num, 10)
        XCTAssertEqual(board.board[2][0].num, 15)
        XCTAssertEqual(board.board[3][0].num, 20)
        XCTAssertEqual(board.board[4][0].num, 0)
    }
    
    func testMoveRowDown() {
        let board = Board(5, 5)
        
        
        let move = Move(axis: .Row, index: 0, n: 1)
        board.move(move)
        
        XCTAssertEqual(board.board[0][0].num, 20)
        XCTAssertEqual(board.board[1][0].num, 0)
        XCTAssertEqual(board.board[2][0].num, 5)
        XCTAssertEqual(board.board[3][0].num, 10)
        XCTAssertEqual(board.board[4][0].num, 15)
    }
}
