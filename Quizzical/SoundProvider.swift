//
//  SoundProvider.swift
//  Quizzical
//
//  Created by Casey Conway on 4/25/19.
//  Copyright © 2019 Casey Conway. All rights reserved.
//

//ABOUT - This file models the game sounds

import AudioToolbox

//Custom type created to hold related values and functions for game sounds
class GameSound {
    var systemSoundID: SystemSoundID = 0
    let fileName: String
    
    init (fileName: String) {
        self.fileName = fileName
    }
    
    //Plays game sound
    func playGameSound(){
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    //Loads game sound
    func loadGameSounds() {
        let path = Bundle.main.path(forResource: fileName, ofType: "m4a")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &systemSoundID)
    }
}

struct GameSoundSet {
    //Declare properties of custom type GameSound
    static let gameLoadSound = GameSound(fileName: "GameLoadSound")
    static let gameStartSound = GameSound(fileName: "GameStartSound")
    static let gameEndSound = GameSound(fileName: "GameEndSound")
    static let timesUpSound = GameSound(fileName: "TimesUpSound")
    static let incorrectAnswerSound = GameSound(fileName: "IncorrectAnswerSound")
    static let correctAnswerSound = GameSound(fileName: "CorrectAnswerSound")
    
    //Organize all the sounds in an array
    static let gameSoundSet: [GameSound] = [gameLoadSound,gameStartSound,gameEndSound,timesUpSound,incorrectAnswerSound,correctAnswerSound]
}

class GameSounds {
    //Declare properties of custom type GameSound
    static let gameLoadSound = GameSound(fileName: "GameLoadSound")
    static let gameStartSound = GameSound(fileName: "GameStartSound")
    static let gameEndSound = GameSound(fileName: "GameEndSound")
    static let timesUpSound = GameSound(fileName: "TimesUpSound")
    static let incorrectAnswerSound = GameSound(fileName: "IncorrectAnswerSound")
    static let correctAnswerSound = GameSound(fileName: "CorrectAnswerSound")
    
    //Organize all the sounds in an array
    let gameSoundSet: [GameSound] = [gameLoadSound,gameStartSound,gameEndSound,timesUpSound,incorrectAnswerSound,correctAnswerSound]
    
    //Load game sounds
    func loadGameSounds() {
        for gameSound in gameSoundSet {
            let path = Bundle.main.path(forResource: gameSound.fileName, ofType: "m4a")
            let soundUrl = URL(fileURLWithPath: path!)
            AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound.systemSoundID)
        }
    }
}

