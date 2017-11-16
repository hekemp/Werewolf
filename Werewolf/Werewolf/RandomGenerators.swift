//
//  RandomGenerators.swift
//  Werewolf
//
//  Created by macbook_user on 11/14/17.
//  Copyright © 2017 CS4980-Werewolf. All rights reserved.
//

import Foundation
import GameplayKit
class RandomGenerators{
    static let gen = RandomGenerators()
    private var villageMarkovChain : [String : [Character : Double]]
    private var nameMarkovChain : [String : [Character : Double]]
    private var random : GKRandom
    private var occupations = ["Doctor",
                               "Baker",
                               "Farmer",
                               "Farmer",
                               "Farmer",
                               "Priest",
                               "Brewer",
                               "Innkeeper",
                               "Hunter"]
    private init() {
        villageMarkovChain = RandomGenerators.genMarkovChain(Bundle.main.path(forResource: "town-name-corpus", ofType: "csv")!)
        nameMarkovChain = RandomGenerators.genMarkovChain(Bundle.main.path(forResource: "CSV_Database_of_First_Names", ofType: "csv")!)
        random = GKRandomSource()
    }
    func getRandomOccupation() -> String{
        let choice = random.nextInt(upperBound: occupations.count)
        return occupations[choice]
    }
    func getRandomName() -> String {
        return RandomGenerators.getRandomMkv(random, self.nameMarkovChain)
    }
    func getRandomVillageName() -> String{
        return RandomGenerators.getRandomMkv(random, self.villageMarkovChain)
    }
    func getRandomAge() -> String{
        //generates a random age between 6 and 114, left skewed
        let ageDist = GKGaussianDistribution(randomSource: random, lowestValue: 33019, highestValue: 52415)
        let ageRaw = Double(ageDist.nextInt())/10000
        let ageFloat = ageRaw*ageRaw*ageRaw-30
        let ageInt = Int(round(ageFloat))
        return String(ageInt)
    }
    func getRandomGender() -> String{
        let choice = Int(arc4random_uniform(2))
        return ["male", "female"][choice]
    }
    static func getRandomMkv(_ randomSrc: GKRandom, _ mkv:[String : [Character : Double]]) -> String{
        var c1 = "^"
        var c2 = "^"
        var c : Character?
        var result = ""
        while(true){
            let key = c1+c2
            let pdf = mkv[key]
            var choice = Double(randomSrc.nextUniform())
            for (char, prob) in pdf!{
                if(choice<prob){
                    c = char
                    break
                }
                else{
                    choice-=prob
                }
            }
            if(c==Character("$")){
                break
            }
            if let c = c{
                result.append(c)
                c1 = c2
                c2 = String(c)
            }
        }
        return result
    }
    static func normalize(_ pdf: [Character : Double])-> [Character : Double]{
        let s = pdf.reduce(0) { (part : Double, arg1) -> Double in
            let (_, p) = arg1
            return part+p
        }
        return pdf.mapValues({ (p : Double) -> Double in
            return p/s
        })
    }
    static func genMarkovChain(_ filename: String) -> [String : [Character : Double]]{
        var mkv = [:] as [String : [Character : Double]]
        if let aStreamReader = StreamReader(path: filename) {
            defer {
                aStreamReader.close()
            }
            while let line = aStreamReader.nextLine() {
                var c1 = "^"
                var c2 = "^"
                var word = line[...line.index(before: line.endIndex)]+"$"
                for c in word.characters{
                    let key = c1 + c2
                    if var counts = mkv[key]{
                        if let count = counts[c]{
                            mkv[key]![c] = count + 1
                        }
                        else{
                            mkv[key]![c] = 1
                        }
                    }
                    else{
                        mkv[key] = [c : 1]
                    }
                    c1 = c2
                    c2 = String(c)
                }
            }
        }
        else{
            print("failed to open file")
        }
        return mkv.mapValues({ (pdf) -> [Character : Double] in
            return normalize(pdf)
        })
    }
}
