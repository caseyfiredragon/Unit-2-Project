//
//  QuizManager.swift
//  Quizzical
//
//  Created by Casey Conway on 4/29/19.
//  Copyright © 2019 Casey Conway. All rights reserved.
//

//ABOUT - This file includes all the logic for managing and providing the quiz questions and answers

import GameKit

class QuizManager {
    //questionAndAnswerSet stores all the Q&A data
    //Answer numbers start at 1 which corresponds to array position zero in "answers"
    //This set has some answer options removed so some questions only have three answer options
    let qAndASet = [QAndA(question: "This was the only US President to serve more than two consecutive terms.", answers: [ "George Washington", "Franklin D. Roosevelt", "Woodrow Wilson", "Andrew Jackson"], correctAnswerNumber: 2),
                                QAndA(question: "Which of the following countries has the most residents?", answers: [ "Nigeria", "Russia", "Iran"], correctAnswerNumber: 1),
                                QAndA(question: "In what year was the United Nations founded?", answers: [ "1918", "1919", "1945", "1954"], correctAnswerNumber: 3),
                                QAndA(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", answers: [ "Paris", "Washington D.C.", "New York City", "Boston"], correctAnswerNumber: 3),
                                QAndA(question: "Which nation produces the most oil?", answers: [ "Iran", "Iraq", "Brazil", "Canada"], correctAnswerNumber: 4),
                                QAndA(question: "Which country has most recently won consecutive World Cups in Soccer?", answers: [ "Italy", "Brazil", "Argentina", "Spain"], correctAnswerNumber: 2),
                                QAndA(question: "Which of the following rivers is longest?", answers: [ "Yangtze", "Mississippi", "Congo"], correctAnswerNumber: 2),
                                QAndA(question: "Which city is the oldest?", answers: [ "Mexico City", "Cape Town", "San Juan"], correctAnswerNumber: 1),
                                QAndA(question: "Which country was the first to allow women to vote in national elections?", answers: [ "Poland", "United States", "Sweden"], correctAnswerNumber: 1),
                                QAndA(question: "Which of these countries won the most medals in the 2012 Summer Games?", answers: [ "France", "Germany", "Japan", "Great Britian"], correctAnswerNumber: 4)]
    
    
    var correctAnswers = 0 //Keeps track of correct answers
    
    //Array used to track what questions remain unasked...
    //by storing the index of their position in the qAndASet array.
    //Index values are removed from this array when a question is asked.
    var unaskedQuestionIndices: [Int]
    var currentQuestion: QAndA //Keeps track of the current question
    let totalQuestions: Int
   
    init (){
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

