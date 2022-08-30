//
//  LevelParser.swift
//  Match Out
//
//  Created by Леванов Алексей on 30.08.2022.
//

import Foundation

/// Парсер уровней
class LevelParser {
    
    func loadLevel(levelName name: String) -> LevelModel? {
        if let localData = self.readLocalFile(forName: name) {
            return self.parse(jsonData: localData)
        }
        return nil
    }
    
//    func loadTotalNumberOfLevels() -> Int {
//        if let localData = self.readLocalFile(forName: "levels") {
//            if let levelsInfo: LevelsInfo = self.parseLevelsInfo(jsonData: localData) {
//                return levelsInfo.totalNumberOfLevels
//            }
//            return 0
//        }
//        return 0
//    }
    
//    private func parseLevelsInfo(jsonData: Data) -> LevelsInfo? {
//        do {
//            let decodedData = try JSONDecoder().decode(LevelsInfo.self,
//                                                       from: jsonData)
//            return decodedData
//        } catch {
//            print("decode error")
//        }
//        return nil
//    }
    
    private func parse(jsonData: Data) -> LevelModel? {
        do {
            let decodedData = try JSONDecoder().decode(LevelModel.self,
                                                       from: jsonData)
            
//            print("MapType: ", decodedData.mapType)
            return decodedData
        } catch {
            print("decode error")
        }
        return nil
    }

    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}
