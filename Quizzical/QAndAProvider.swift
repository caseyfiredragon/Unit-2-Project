//
//  QuizQuestionProvider.swift
//  Quizzical
//
//  Created by Casey Conway on 4/21/19.
//  Copyright © 2019 Casey Conway. All rights reserved.
//

//ABOUT - This file contains the question and answer data and struct

//Stores the questions and answers for a given question and provides functions to access and check it
struct QAndA {
    let question: String
    let answers: [String]
    let correctAnswerNumber: Int // Range 1 - 4
    
    //Check if the answer is correct given the number (starting at 1)
    func isAnswerCorrect(forSelectedAnswerNumber selectedAnswerNumber: Int) -> Bool {
        return correctAnswerNumber == selectedAnswerNumber
    }
    
    //Return a string of the correct answer for a given QAndA
    func returnCorrectAnswer() -> String {
        return answers[correctAnswerNumber-1]
    }
}
