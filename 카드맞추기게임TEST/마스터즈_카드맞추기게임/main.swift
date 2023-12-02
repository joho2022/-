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



var count = 0
var collectedCount = 0

var flatMapDeck = cardBoard.flatMap { $0 }
var totalDeck = NSCountedSet(array: flatMapDeck)


/// 카드 맞추기 게임 실행
func playCardMatching() {
    var selectedCard = [(Int, Int)]()
    
    while (1...8).map({totalDeck.count(for: $0)}).filter({ $0 >= 2 }) != [] && collectedCount < 18 {
        openCardBoard(cardBoard: cardBoard, isOpenCard: isOpenCard) // 1단계
        print("<시도 \(count + 1), 남은 카드: \(18 - collectedCount)> 좌표를 두번 입력하세요")
        
       
        guard let input = readLine()?.replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: ""),
              let row = Int(input.split(separator: ", ")[0]),
              let column = Int(input.split(separator: ", ")[1]),
              input.split(separator: ", ").count == 2,
              row >= 1 && row <= 3, column >= 1 && column <= 6 else {
            print("[잘못된 입력] \n((1~3), (1~6))범위 이내로\n아래와 같이 숫자만 입력하세요\n예시)(1, 2)")
            continue
        }
        
        
        let selectedRow = row - 1
        let selectedColumn = column - 1
        
        isOpenCard[selectedRow][selectedColumn] = true
        
      
        selectedCard.append((selectedRow, selectedColumn))
      
        
        if selectedCard.count == 2 {
            if selectedCard[0] != selectedCard[1] {
                openCardBoard(cardBoard: cardBoard, isOpenCard: isOpenCard)
                print("-----구분선-----")
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
                    
                } else {
                    count += 1
                    isOpenCard[first.0][first.1] = false
                    isOpenCard[second.0][second.1] = false
                }
                
            } else {
                isOpenCard[selectedRow][selectedColumn] = false
                print("[잘못된 입력] \n같은 좌표를 연속으로 입력하지 마세요")
            }
            selectedCard = [] //초기화
        }
    }
    
    print("축하합니다. 카드를 모두 맞췄습니다.")
}





playCardMatching()
