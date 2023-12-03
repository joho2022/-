//
//  main.swift
//  마스터즈_카드맞추기게임
//
//  Created by 조호근 on 12/1/23.
//

import Foundation

var deck = [Int](repeating: 0, count: 24)


for i in 0..<8 {
    deck[i] = i + 1
    deck[i + 8] = i + 1
    deck[i + 16] = i + 1
}

deck.shuffle()




var cardBoard = [[Int]](repeating: [Int](repeating: 0, count: 6), count: 3)

var deckIndex = 0
for i in 0..<3 {
    for j in 0..<6 {
        cardBoard[i][j] = deck[deckIndex]
        deckIndex += 1
        
    }
}

var isOpenCard = [[Bool]](repeating: [Bool](repeating: false, count: 6), count: 3)


/// 게임시작하면 카드를 화면에 출력하는 함수입니다.
///
/// isOpenCard 중첩배열이 true면 뒤집힌 카드가 오픈이 된다.
///
/// 오픈이 되는 와중에 두 카드가 일치하여 숫자 0으로 바뀌게 되면, 해당 카드를 제거하고 화면에 출력된다.
/// - Parameters:
///   - cardBoard: 카드를 섞어둔 덱에서 카드 18장을 순서대로 뽑은 3행 6열 배열
///   - isOpenCard: Bool타입을 가지는 3행 6열 배열
/// - Returns: 카드의 상태가 문자열로 반환됩니다.
func openCardBoard(cardBoard: [[Int]], isOpenCard: [[Bool]]) {
    for i in 0..<3 {
        for j in 0..<6 {
            if isOpenCard[i][j] {
                if cardBoard[i][j] > 0 {
                    print(cardBoard[i][j], terminator: " ")
                } else {
                    print(" ", terminator: " ")
                }
            } else {
                print("X", terminator: " ")
            }
        }
        print()
    }
}






/// 카드 맞추기 게임 실행
func playCardMatching() {
    var count = 0
    var collectedCount = 0
    
    var flatMapDeck = cardBoard.flatMap { $0 }
    var totalDeck = NSCountedSet(array: flatMapDeck)
    
    var playerScore1 = 0
    var playerScore2 = 0
    var playerName1 = ""
    var playerName2 = ""
    
    var selectedCard = [(Int, Int)]()
    
    // player 이름을 2개 받을 떄까지 반복
    while playerName1.isEmpty && playerName2.isEmpty {
        print("첫번째 플레이어 이름을 입력하세요")
        guard let player1 = readLine(), !player1.isEmpty else {
            print("한 글자이상 이름을 입력하세요")
            continue
        }
        
        print("두번째 플레이어 이름을 입력하세요")
        guard let player2 = readLine(), !player2.isEmpty else {
            print("한 글자이상 이름을 입력하세요")
            continue
        }
        
        playerName1 = player1
        playerName2 = player2
    }
    
    // 1P부터 게임 시작
    var currentPlayer = playerName1
    var baseScore = 10
    
    
    while (1...8).map({totalDeck.count(for: $0)}).filter({ $0 >= 2 }) != [] && collectedCount < 18 {
        print("[\(playerName1)] \(playerScore1)점 vs [\(playerName2)] \(playerScore2)점")
        print("---\(currentPlayer)님의 차례입니다.---")
        openCardBoard(cardBoard: cardBoard, isOpenCard: isOpenCard) // 1단계
        print("<시도 \(count + 1), 남은 카드: \(18 - collectedCount)> 좌표를 두번 입력하세요")
        
        
        guard let input = readLine()?.replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: ""),
              let row = Int(input.split(separator: ", ")[0]),
              let column = Int(input.split(separator: ", ")[1]),
              input.split(separator: ", ").count == 2,
              row >= 1 && row <= 3, column >= 1 && column <= 6 else {
            print("[잘못된 입력] \n((1~3), (1~6))범위 이내로\n아래와 같이 숫자만 입력하세요\n예시)(1, 2)\n")
            continue
        }
        
        let selectedRow = row - 1
        let selectedColumn = column - 1
        
//        guard let cardBoard[selectedRow][selectedColumn] > 0
//        
//        if cardBoard[selectedRow][selectedColumn] > 0 {
//            isOpenCard[selectedRow][selectedColumn] = true
//        }
        isOpenCard[selectedRow][selectedColumn] = true
        selectedCard.append((selectedRow, selectedColumn))
        
        
        if selectedCard.count == 2 {
            if selectedCard[0] != selectedCard[1] {
                openCardBoard(cardBoard: cardBoard, isOpenCard: isOpenCard)
                print("-----구분선-----\n")
                let first = selectedCard[0]
                let second = selectedCard[1]
                
                if cardBoard[first.0][first.1] == cardBoard[second.0][second.1] {
                    count += 1
                    collectedCount += 2
                    isOpenCard[first.0][first.1] = true
                    isOpenCard[second.0][second.1] = true
                    cardBoard[first.0][first.1] = 0
                    cardBoard[second.0][second.1] = 0
                    
                    flatMapDeck = cardBoard.flatMap { $0 }
                    totalDeck = NSCountedSet(array: flatMapDeck)
                    
                    
                    
                    currentPlayer == playerName1 ? (playerScore1 += baseScore) : (playerScore2 += baseScore)
                    baseScore *= 2
                    
                    
                } else {
                    count += 1
                    
                    isOpenCard[first.0][first.1] = false
                    isOpenCard[second.0][second.1] = false
 
                    
                    // 카드가 제거된 좌표와 오픈할려는 카드와 같이 고르면 제거된 카드 좌표에서 다시 X표시가 나타나는 문제를 해결
                    if cardBoard[first.0][first.1] == 0 && cardBoard[second.0][second.1] > 0 {
                        isOpenCard[first.0][first.1] = true
                        print("첫 번째 카드는 이미 제거된 카드입니다. 턴이 넘어갑니다.")
                    } else if cardBoard[first.0][first.1] > 0 && cardBoard[second.0][second.1] == 0 {
                        isOpenCard[second.0][second.1] = true
                        print("두 번째 카드는 이미 제거된 카드입니다. 턴이 넘어갑니다.")
                    }
                    
                    
                    currentPlayer == playerName1 ? (currentPlayer = playerName2) : (currentPlayer = playerName1)
                    baseScore = 10
                }
                
            } else {
                isOpenCard[selectedRow][selectedColumn] = false
                print("[잘못된 입력] \n같은 좌표를 연속으로 입력하지 마세요\n")
            }
            selectedCard = [] //초기화
        }
    }
    print("\n축하합니다. 카드를 모두 맞췄습니다.")
    print("---[최종 점수]---")
    print("[\(playerName1)] \(playerScore1)점 vs [\(playerName2)] \(playerScore2)점")
    if playerScore1 > playerScore2 {
        print("\(playerName1)님이 우승하였습니다!")
    } else {
        print("\(playerName2)님이 우승하였습니다!")
    }
}

playCardMatching()
