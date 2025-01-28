import UIKit

let moons = "🌕🌖🌗🌘🌑🌒🌓🌔🌕"
let space = " "
let moonCount = moons.count
//print(moonCount)

// I based this off JHT's code, but definitely want to talk about it more. still confused
func charAt(_ str: String, _ pos: Int) -> String {
    let index = moons.index(moons.startIndex, offsetBy: pos)
    let char = moons[index]
    return String(char)
}

let randomInt = Int.random(in: 0...moons.count)

let whichMoon = charAt(moons, randomInt)
//print(whichMoon)

func newLine(_ n: Int) {
    var newMoons = ""
    for _ in 0...moonCount {
        let randomInt = Int.random(in: 0..<moonCount)
        newMoons += charAt(moons, randomInt)
    }
    print(newMoons)
}

//var moonLine = newLine(5)

func moonPhase(_ n: Int) {
    for _ in 0..<n {
        let randomInt = Int.random(in: 0...n)
        newLine(randomInt)
    }
//    print(moonPhase) // this was causing it to print "(Function)" -- why?
}
let randomInt1 = Int.random(in: 0...moonCount)

print("guys i think the moon is broken")
print()
moonPhase(randomInt)
print()
print("ok lemme try again")
print()
moonPhase(randomInt1)
print()
print("yeah she broke")

// result (changes every time):

// guys i think the moon is broken
//
//🌕🌕🌔🌔🌖🌒🌔🌕🌘🌓
//🌕🌔🌑🌔🌒🌒🌓🌒🌕🌘
//🌖🌕🌗🌔🌕🌔🌘🌑🌑🌕
//🌔🌗🌗🌘🌗🌕🌔🌒🌕🌗
//🌘🌘🌕🌑🌒🌕🌑🌘🌗🌓
//🌑🌓🌕🌔🌓🌗🌒🌕🌕🌒
//🌖🌓🌑🌒🌔🌑🌑🌑🌒🌕
//🌔🌖🌓🌔🌔🌖🌗🌕🌔🌔
//
//ok lemme try again
//
//🌘🌔🌘🌗🌘🌖🌕🌖🌒🌒
//🌔🌕🌕🌕🌘🌓🌒🌖🌓🌓
//🌓🌘🌕🌑🌘🌔🌕🌑🌕🌘
//🌘🌓🌓🌕🌓🌒🌔🌓🌔🌖
//🌔🌒🌖🌓🌕🌘🌒🌕🌔🌓
//🌕🌕🌑🌖🌓🌒🌔🌑🌓🌕
//🌖🌘🌑🌕🌕🌕🌘🌗🌘🌖
//
//yeah she broke
