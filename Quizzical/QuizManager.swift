//
//  QuizManager.swift
//  Quizzical
//
//  Created by Casey Conway on 4/29/19.
//  Copyright © 2019 Casey Conway. All rights reserved.
//
import GameKit

class QuizManager {
    var correctAnswers = 0 //Keeps track of correct answers
    
    let qAndASet: [QAndA]
    //Array used to track what questions remain unasked...
    //by storing the index of their position in the qAndASet array.
    //Index values are removed from this array when a question is asked.
    var unaskedQuestionIndices: [Int]
    var currentQuestion: QAndA //Keeps track of the current question
    let totalQuestions: Int
   
    init (qAndASet: [QAndA]){
        self.qAndASet = qAndASet
        self.unaskedQuestionIndices = Array(0...(qAndASet.count - 1))
        self.currentQuestion = qAndASet[0]
        self.totalQuestions = qAndASet.count //Total number of questions
    }
    
    //Functions
    
    // Check if the game is over by seeing if we've run out of unasked questions
    func isGameOver()->Bool{
        return unaskedQuestionIndices.count == 0
    }
    
    //Check if the game is just beginning by seeing if we're full of questions
    func isGameBeginning()->Bool{
        return unaskedQuestionIndices.count == totalQuestions
    }
    
    //Return a random question that hasn't been asked before
    func returnRandomUnaskedQuestion() -> QAndA {
        //Get a random question that hasn't been asked before
        let randomIndex = GKRandomSource.sharedRandom().nextInt(upperBound: unaskedQuestionIndices.count-1)
        let currentQuestionIndex = unaskedQuestionIndices[randomIndex]
        currentQuestion = qAndASet[currentQuestionIndex]
        //remove question index from the array of unasked questions
        unaskedQuestionIndices.remove(at: randomIndex)
        return currentQuestion
    }
    
    //Reset unasked question indices and number of correct answers
    func resetQuiz (){
        unaskedQuestionIndices = Array(0...(qAndASet.count - 1))
        correctAnswers = 0
    }
    
    func gotMoreThanHalfCorrect()->Bool {
        return correctAnswers * 2 >= totalQuestions
    }
    
    func returnScoreString()->String{
        return "\(correctAnswers) of \(totalQuestions) correct."
    }
    
}

let quizManager = QuizManager(qAndASet: questionAndAnswerSet)
