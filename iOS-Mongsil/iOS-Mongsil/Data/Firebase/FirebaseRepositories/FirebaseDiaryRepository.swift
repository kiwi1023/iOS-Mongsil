//
//  FirebaseDiaryRepository.swift
//  iOS-Mongsil
//
//  Created by Kiwi, Groot on 2023/01/30.
//

import Combine
import FirebaseAuth

final class FirebaseDiaryRepository: DiaryRepository {
    private let firebaseManager = FirebaseManager<DiaryDTO>(rootChildID: "DiaryModel")
    private let uid = Auth.auth().currentUser?.uid ?? ""
    
    func create(input: Diary) -> AnyPublisher<Void, Error> {
        let diaryDTO = mapToDiaryDTO(input)
        
        return firebaseManager.setValue(uid: self.uid, childId: diaryDTO.id, model: diaryDTO)
    }
    
    func read() -> AnyPublisher<[Diary], Error> {
        firebaseManager.readAllValue(uid: uid)
            .mapError { $0 as Error }
            .tryMap({ diaryDTOs in
                let diarys = diaryDTOs.compactMap { [weak self] in
                    self?.mapToDiary($0)
                }
                
                return diarys.sorted { $0.date < $1.date }
            })
            .eraseToAnyPublisher()
    }
    
    func delete(id: String) -> AnyPublisher<Void, Error> {
        firebaseManager.deleteValue(uid: self.uid, childId: id)
    }
}

extension FirebaseDiaryRepository {
    private func mapToDiaryDTO(_ diary: Diary) -> DiaryDTO {
        DiaryDTO(id: diary.id,
                 date: diary.date,
                 url: diary.url,
                 squareUrl: diary.squareUrl)
    }
    
    private func mapToDiary(_ diaryDTO: DiaryDTO) -> Diary {
        Diary(id: diaryDTO.id,
              date: diaryDTO.date,
              url: diaryDTO.url,
              squareUrl: diaryDTO.squareUrl)
    }
}


