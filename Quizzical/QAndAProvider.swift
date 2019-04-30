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

//qAndASet stores all the Q&A data
//Answer numbers start at 1 which corresponds to array position zero in "answers"
//This set has some answer options removed so some questions only have three answer options
let questionAndAnswerSet = [QAndA(question: "This was the only US President to serve more than two consecutive terms.", answers: [ "George Washington", "Franklin D. Roosevelt", "Woodrow Wilson", "Andrew Jackson"], correctAnswerNumber: 2),
                QAndA(question: "Which of the following countries has the most residents?", answers: [ "Nigeria", "Russia", "Iran"], correctAnswerNumber: 1),
                QAndA(question: "In what year was the United Nations founded?", answers: [ "1918", "1919", "1945", "1954"], correctAnswerNumber: 3),
                QAndA(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", answers: [ "Paris", "Washington D.C.", "New York City", "Boston"], correctAnswerNumber: 3),
                QAndA(question: "Which nation produces the most oil?", answers: [ "Iran", "Iraq", "Brazil", "Canada"], correctAnswerNumber: 4),
                QAndA(question: "Which country has most recently won consecutive World Cups in Soccer?", answers: [ "Italy", "Brazil", "Argentina", "Spain"], correctAnswerNumber: 2),
                QAndA(question: "Which of the following rivers is longest?", answers: [ "Yangtze", "Mississippi", "Congo"], correctAnswerNumber: 2),
                QAndA(question: "Which city is the oldest?", answers: [ "Mexico City", "Cape Town", "San Juan"], correctAnswerNumber: 1),
                QAndA(question: "Which country was the first to allow women to vote in national elections?", answers: [ "Poland", "United States", "Sweden"], correctAnswerNumber: 1),
                QAndA(question: "Which of these countries won the most medals in the 2012 Summer Games?", answers: [ "France", "Germany", "Japan", "Great Britian"], correctAnswerNumber: 4)]


/*
//This is the original data set for which each question has four answer options
let qAndASet = [QAndA(question: "This was the only US President to serve more than two consecutive terms.", answers: [ "George Washington", "Franklin D. Roosevelt", "Woodrow Wilson", "Andrew Jackson"], correctAnswerNumber: 2),
                QAndA(question: "Which of the following countries has the most residents?", answers: [ "Nigeria", "Russia", "Iran", "Vietnam"], correctAnswerNumber: 1),
                QAndA(question: "In what year was the United Nations founded?", answers: [ "1918", "1919", "1945", "1954"], correctAnswerNumber: 3),
                QAndA(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", answers: [ "Paris", "Washington D.C.", "New York City", "Boston"], correctAnswerNumber: 3),
                QAndA(question: "Which nation produces the most oil?", answers: [ "Iran", "Iraq", "Brazil", "Canada"], correctAnswerNumber: 4),
                QAndA(question: "Which country has most recently won consecutive World Cups in Soccer?", answers: [ "Italy", "Brazil", "Argentina", "Spain"], correctAnswerNumber: 2),
                QAndA(question: "Which of the following rivers is longest?", answers: [ "Yangtze", "Mississippi", "Congo", "Mekong"], correctAnswerNumber: 2),
                QAndA(question: "Which city is the oldest?", answers: [ "Mexico City", "Cape Town", "San Juan", "Sydney"], correctAnswerNumber: 1),
                QAndA(question: "Which country was the first to allow women to vote in national elections?", answers: [ "Poland", "United States", "Sweden", "Senegal"], correctAnswerNumber: 1),
                QAndA(question: "Which of these countries won the most medals in the 2012 Summer Games?", answers: [ "France", "Germany", "Japan", "Great Britian"], correctAnswerNumber: 4)]
*/





