//
//  QuestionModel.swift
//  JamyungJong
//
//  Created by t2023-m0072 on 1/10/25.
//
//


import Foundation

struct Question {
    let text: String
    let answer: Int
}

class QuestionGenerator {
    static func generateRandomQuestions(count: Int) -> [Question] {
        var questions: [Question] = []
        for _ in 0..<count {
            let num1 = Int.random(in: 1...15)
            let num2 = Int.random(in: 1...15)
            let text = "\(num1) + \(num2)"
            let answer = num1 + num2
            questions.append(Question(text: text, answer: answer))
        }
        return questions
    }
}
