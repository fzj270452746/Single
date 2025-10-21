
import UIKit

struct Wam_Ka_Model {
    var id_tim: String
    var base_tim: SingleMJModel
    var seconds_left_tim: Int
    var expired_tim: Bool
    var selected_tim: Bool
}

extension Wam_Ka_Model {
    static func singleMakeDeck(count_tim: Int, pairs_mode_tim: Bool) -> [Wam_Ka_Model] {
        var deck_tim: [Wam_Ka_Model] = []
        if pairs_mode_tim {
            // Ensure even count and strictly one pair per tile type
            let evenCount = count_tim % 2 == 0 ? count_tim : count_tim - 1
            let pool_tim: [SingleMJModel] = [
                singleMJ1Tong, singleMJ2Tong, singleMJ3Tong, singleMJ4Tong, singleMJ5Tong, singleMJ6Tong, singleMJ7Tong, singleMJ8Tong, singleMJ9Tong,
                singleMJ1Tiao, singleMJ2Tiao, singleMJ3Tiao, singleMJ4Tiao, singleMJ5Tiao, singleMJ6Tiao, singleMJ7Tiao, singleMJ8Tiao, singleMJ9Tiao,
                singleMJ1Wan, singleMJ2Wan, singleMJ3Wan, singleMJ4Wan, singleMJ5Wan, singleMJ6Wan, singleMJ7Wan, singleMJ8Wan, singleMJ9Wan
            ]
            
            // Shuffle pool and pick unique tiles, each exactly twice
            var shuffledPool = pool_tim.shuffled()
            let neededPairs = evenCount / 2
            for i in 0..<min(neededPairs, shuffledPool.count) {
                let tile = shuffledPool[i]
                let s1 = Int.random(in: 15...30)
                let s2 = Int.random(in: 15...30)
                deck_tim.append(Wam_Ka_Model(id_tim: UUID().uuidString, base_tim: tile, seconds_left_tim: s1, expired_tim: false, selected_tim: false))
                deck_tim.append(Wam_Ka_Model(id_tim: UUID().uuidString, base_tim: tile, seconds_left_tim: s2, expired_tim: false, selected_tim: false))
            }
            
            deck_tim.shuffle()
            return deck_tim
        } else {
            // Runs mode: build in triples of consecutive numbers within the same category
            // Allow tiles to be reused in different runs to reach desired count
            let tripleCount = (count_tim / 3) * 3
            
            // Generate all possible runs: [cat, start] where start in 1...7
            var possibleRuns: [(String, Int)] = []
            let categories = [categoryTong, categoryTiao, categoryWan]
            for cat in categories {
                for start in 1...7 {
                    possibleRuns.append((cat, start))
                }
            }
            
            var built = 0
            while built < tripleCount {
                // Keep shuffling and picking runs until we reach desired count
                possibleRuns.shuffle()
                for (cat, start) in possibleRuns {
                    guard built < tripleCount else { break }
                    
                    if let m1 = singleModel(category: cat, num: start),
                       let m2 = singleModel(category: cat, num: start + 1),
                       let m3 = singleModel(category: cat, num: start + 2) {
                        deck_tim.append(Wam_Ka_Model(id_tim: UUID().uuidString, base_tim: m1, seconds_left_tim: Int.random(in: 15...30), expired_tim: false, selected_tim: false))
                        deck_tim.append(Wam_Ka_Model(id_tim: UUID().uuidString, base_tim: m2, seconds_left_tim: Int.random(in: 15...30), expired_tim: false, selected_tim: false))
                        deck_tim.append(Wam_Ka_Model(id_tim: UUID().uuidString, base_tim: m3, seconds_left_tim: Int.random(in: 15...30), expired_tim: false, selected_tim: false))
                        built += 3
                    }
                }
            }
            
            deck_tim.shuffle()
            return deck_tim
        }
    }

    static func singleModel(category: String, num: Int) -> SingleMJModel? {
        switch category {
        case categoryTong:
            switch num {
            case 1: return singleMJ1Tong
            case 2: return singleMJ2Tong
            case 3: return singleMJ3Tong
            case 4: return singleMJ4Tong
            case 5: return singleMJ5Tong
            case 6: return singleMJ6Tong
            case 7: return singleMJ7Tong
            case 8: return singleMJ8Tong
            case 9: return singleMJ9Tong
            default: return nil
            }
        case categoryTiao:
            switch num {
            case 1: return singleMJ1Tiao
            case 2: return singleMJ2Tiao
            case 3: return singleMJ3Tiao
            case 4: return singleMJ4Tiao
            case 5: return singleMJ5Tiao
            case 6: return singleMJ6Tiao
            case 7: return singleMJ7Tiao
            case 8: return singleMJ8Tiao
            case 9: return singleMJ9Tiao
            default: return nil
            }
        case categoryWan:
            switch num {
            case 1: return singleMJ1Wan
            case 2: return singleMJ2Wan
            case 3: return singleMJ3Wan
            case 4: return singleMJ4Wan
            case 5: return singleMJ5Wan
            case 6: return singleMJ6Wan
            case 7: return singleMJ7Wan
            case 8: return singleMJ8Wan
            case 9: return singleMJ9Wan
            default: return nil
            }
        default:
            return nil
        }
    }

    static func singleIsSamePair(_ a_tim: Wam_Ka_Model, _ b_tim: Wam_Ka_Model) -> Bool {
        let categoryMatch = a_tim.base_tim.sing_category == b_tim.base_tim.sing_category
        let titleMatch = a_tim.base_tim.sing_title == b_tim.base_tim.sing_title
        let result = categoryMatch && titleMatch
        
        print("🎴 Pairs Check:")
        print("  Card A: category=\(a_tim.base_tim.sing_category), title=\(a_tim.base_tim.sing_title), expired=\(a_tim.expired_tim)")
        print("  Card B: category=\(b_tim.base_tim.sing_category), title=\(b_tim.base_tim.sing_title), expired=\(b_tim.expired_tim)")
        print("  Category Match: \(categoryMatch)")
        print("  Title Match: \(titleMatch)")
        print("  ✅ Result: \(result)")
        
        return result
    }

    static func singleIsRun(_ arr_tim: [Wam_Ka_Model]) -> Bool {
        guard arr_tim.count == 3 else { return false }
        let cat_tim = arr_tim[0].base_tim.sing_category
        if !arr_tim.allSatisfy({ $0.base_tim.sing_category == cat_tim }) { return false }
        let nums_tim = arr_tim.compactMap { Int($0.base_tim.sing_title) }.sorted()
        guard nums_tim.count == 3 else { return false }
        return nums_tim[0] + 1 == nums_tim[1] && nums_tim[1] + 1 == nums_tim[2]
    }
}


