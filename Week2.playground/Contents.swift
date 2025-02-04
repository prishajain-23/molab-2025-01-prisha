//: Loading and displaying ascii art from app bundle

import Foundation

// load text file from bundle
func load(_ file :String) -> String {
  let path = Bundle.main.path(forResource: file, ofType: nil)
  let str = try? String(contentsOfFile: path!, encoding: .utf8)
  return str!
}

let moonPhases = [
    "newMoon.txt",
    "waxingCrescent.txt",
    "waxingGibbous.txt",
    "fullMoon.txt",
    "waningGibbous.txt",
    "waningCrescent.txt",
    "newMoon.txt"
]

var loadedPhases: [String] = []

for i in 0..<moonPhases.count {
    let newLoadedPhase = load(moonPhases[i])
    loadedPhases.append(newLoadedPhase)
//    print(loadedPhases)                   // check to see if files are being called properly
}

var splitPhases: [[String]] = []

for phase in loadedPhases {
    splitPhases.append(phase.split(separator: "\n").map { String($0) })
}

// Function to combine moon phase ASCII art with a margin
func combine(_ whichMoon: [[String]], _ margin: Int) -> [String] {
    // Find the length of the longest line across all phases
    var longestLineLength = 0
    for phase in whichMoon {
        for line in phase {
            if line.count > longestLineLength {
                longestLineLength = line.count
            }
        }
    }
    
    // Calculate total width including margin
    let edge = longestLineLength + margin
    
    // Find the maximum number of lines in any phase
    var maxLines = 0
    for phase in whichMoon {
        if phase.count > maxLines {
            maxLines = phase.count
        }
    }
    
    // Array to store combined lines
    var combinedLines: [String] = []
    
    // Iterate through each line position
    for lineIndex in 0..<maxLines {
        // String to build the combined line for this line index
        var combinedLine = ""
        
        // Combine lines from each phase
        for phaseIndex in 0..<whichMoon.count {
            let phase = whichMoon[phaseIndex]
            
            // Get the line for this phase, or use empty string if no line exists
            var line = ""
            if lineIndex < phase.count {
                line = phase[lineIndex]
            }
            
            // Pad the line to consistent length
            var paddedLine = line
            if line.count < edge {
                paddedLine += String(repeating: " ", count: edge - line.count)
            }
            
            // Add padded line to combined line
            combinedLine += paddedLine
        }
        
        // Add this combined line to our results
        combinedLines.append(combinedLine)
    }
    
    // Return the array of combined lines
    return combinedLines
}

// Combine all moon phases with a 1-character margin
let phases = combine(splitPhases, 1)

// Print the combined moon phases
print(phases.joined(separator: "\n"))
