//
//  FirebaseCommentRepository.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/30.
//

import Foundation
import FirebaseAuth
import Combine

final class FirebaseCommentRepository: CommentRepository {
    private let firebaseManager = FirebaseManager<CommentDTO>(rootChildID: "CommentModel")
    private let uid = Auth.auth().currentUser?.uid ?? ""
    
    func create(input: Comment) -> AnyPublisher<Void, Error> {
        let commentDTO = mapToCommtentDTO(input)
        
        return firebaseManager.setValue(uid: uid, childId: commentDTO.id.description, model: commentDTO)
    }
    
    func read() -> AnyPublisher<[Comment], Error> {
        firebaseManager.readAllValue(uid: uid)
            .mapError { $0 as Error }
            .tryMap({ commentDTOs in
                let comments = commentDTOs.compactMap { [weak self] in
                    self?.mapToCommtent($0)
                }
                
                return comments.sorted { $0.date < $1.date }
            })
            .eraseToAnyPublisher()
    }
    
    func update(input: Comment) -> AnyPublisher<Void, Error> {
        let commentDTO = mapToCommtentDTO(input)
        
        return firebaseManager.setValue(uid: uid, childId: commentDTO.id.description, model: commentDTO)
    }
    
    func delete(id: UUID) -> AnyPublisher<Void, Error> {
        firebaseManager.deleteValue(uid: uid, childId: id.description)
    }
}

extension FirebaseCommentRepository {
    private func mapToCommtentDTO(_ comment: Comment) -> CommentDTO {
        CommentDTO(id: comment.id,
                   date: comment.date,
                   emoticon: comment.emoticon.name,
                   text: comment.text)
    }
    
    private func mapToCommtent(_ commentDTO: CommentDTO) -> Comment {
        Comment(id: commentDTO.id,
                date: commentDTO.date,
                emoticon: Emoticon(rawValue: commentDTO.emoticon) ?? .notBad,
                text: commentDTO.text)
    }
}
