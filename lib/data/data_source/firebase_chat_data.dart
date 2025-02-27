import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fmsproject/data/dtos/chat_data_dto.dart';
import 'package:fmsproject/data/dtos/message_data_dto.dart';

import '../../utils/simple_logger.dart';
import '../core/result.dart';

class FirebaseChatData {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //채팅방 리스트 로드(1회)
  Future<Result<List<ChatDataDto>>> getChatList(String userId) async {
    try {
      var snapshot = await _firestore
          .collection('chats')
          .where('participants', arrayContains: userId)
          .orderBy('createdAt', descending: true)
          .get();

      List<ChatDataDto> chatList =
          snapshot.docs.map((doc) => ChatDataDto.fromJson(doc.data())).toList();

      return Result.success(chatList);
    } catch (e) {
      logger.info('Firestore getting chat list error => $e');
      return Result.error(e.toString());
    }
  }

  //채팅방 리스트 로드(실시간 로드)
  Stream<List<ChatDataDto>> getChatListStream(String userId) {
    try {
      return _firestore
          .collection('chats')
          .where('participants', arrayContains: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ChatDataDto.fromJson(doc.data()))
              .toList());
    } catch (e) {
      logger.info(
          'Firestore Stream getting user-specific chat room data error => $e');
      return Stream.value([]); // 오류 발생 시 빈 리스트 반환
    }
  }

  // 특정 채팅방 불러오기
  Future<Result<ChatDataDto>> getChatRoomData(String chatId) async {
    try {
      DocumentSnapshot chatDoc =
          await _firestore.collection('chats').doc(chatId).get();

      if (chatDoc.exists) {
        ChatDataDto chatData =
            ChatDataDto.fromJson(chatDoc.data() as Map<String, dynamic>);
        return Result.success(chatData);
      } else {
        return const Result.error('Chat room not found');
      }
    } catch (e) {
      logger.info('Firestore getting chat room error => $e');
      return Result.error(e.toString());
    }
  }

  // 유저별 메시지 실시간 로드
  Stream<List<MessageDataDto>> getMessagesForUser(String userId) {
    try {
      return _firestore
          .collection('chats')
          .where('participants', arrayContains: userId) // userId가 포함된 채팅방 필터링
          .snapshots()
          .asyncMap((chatSnapshot) async {
        List<MessageDataDto> allMessages = [];

        // 채팅방 목록 가져오기
        for (var chatDoc in chatSnapshot.docs) {
          // 각 채팅방의 메시지를 실시간으로 가져오기
          var messagesStream = _firestore
              .collection('chats')
              .doc(chatDoc.id)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .limit(10)
              .snapshots();

          // 각 채팅방의 메시지를 스트림으로 변환
          await for (var messagesSnapshot in messagesStream) {
            var messages = messagesSnapshot.docs
                .map((doc) => MessageDataDto.fromJson(doc.data()))
                .toList();
            allMessages.addAll(messages);
            break; // 최신 메시지만 가져오고 루프 종료
          }
        }

        return allMessages;
      });
    } catch (e) {
      logger.info(
          'Firestore Stream getting user-specific message data error => $e');
      return Stream.value([]); // 오류 발생 시 빈 리스트 반환
    }
  }

  // 이전 메시지를 로드
  Future<Result<List<MessageDataDto>>> fetchMoreMessages(
      String chatId, Timestamp lastTimestamp) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .startAfter([lastTimestamp]) // 마지막으로 가져온 메시지 이후의 데이터
          .limit(10)
          .get();

      List<MessageDataDto> oldMessages = snapshot.docs
          .map((doc) => MessageDataDto.fromJson(doc.data()))
          .toList();

      return Result.success(oldMessages);
    } catch (e) {
      logger.info('Firestore getting old messages error => $e');
      return Result.error(e.toString());
    }
  }

  // 특정 채팅방의 모든 메시지를 읽음 상태로 업데이트하는 메서드
  Future<Result<int>> markMessagesAsRead(String chatId, String userId) async {
    try {
      // 현재 사용자가 아직 읽지 않은 메시지만 가져오기
      QuerySnapshot messagesSnapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('senderId', isNotEqualTo: userId)
          .get();

      if (messagesSnapshot.docs.isEmpty) {
        return const Result.success(0); // 업데이트할 메시지가 없으면 바로 성공 반환
      }

      // batch 작업 생성
      WriteBatch batch = _firestore.batch();

      int unreadCount = 0;
      for (var doc in messagesSnapshot.docs) {

        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<String> readBy = List<String>.from(data['readByUsers'] ?? []);

        // 보아직 읽지 않은 경우에만 업데이트
        if (!readBy.contains(userId)) {
          readBy.add(userId); // 읽음 상태 추가
          batch.update(doc.reference, {'readByUsers': readBy});
          unreadCount += 1;
        }
      }

      // batch 실행
      await batch.commit();
      return Result.success(unreadCount);
    } catch (e) {
      logger.info('Marking messages as read error => $e');
      return Result.error(e.toString());
    }
  }

  // 채팅방 검색 메서드
  Future<Result<List<String>>> findOrCreateChatRoom(
      String senderId, String receiverId) async {
    try {
      final chatRef = _firestore.collection('chats');

      // 기존 채팅방 검색
      QuerySnapshot existingChats = await chatRef
          .where('participants', isEqualTo: [senderId, receiverId]).get();
      List<String> chatRooms = [];

      for (var doc in existingChats.docs) {
        List<String> participants = List<String>.from(doc['participants']);

        if (participants.contains(receiverId)) {
          chatRooms.add(doc['chatId']);
        }
      }
      if (chatRooms.isNotEmpty) {
        return Result.success(chatRooms);
      } else {
        // 채팅방 없음. 새 채팅방 생성(chatId 를 새로 생성)
        DocumentReference newChatRef = chatRef.doc();
        final String newChatId = newChatRef.id;
        // 파이어베이스에 채팅방 생성
        await newChatRef.set({
          'chatId': newChatId,
          'participants': [senderId, receiverId],
          'createdAt': DateTime.now(),
          'lastMessageId': '',
          'lastMessage': '',
        });

        return Result.success([newChatId]);
      }
    } catch (e) {
      logger.info('Firestore find or create chat room error => $e');
      return Result.error(e.toString());
    }
  }

// 메시지 보내기 메서드
  Future<Result<void>> sendMessage(
      String chatId, MessageDataDto messageData) async {
    try {
      Map<String, dynamic> saveMessage = messageData.toJson();

      // 메시지 저장
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(saveMessage);

      // 채팅방 마지막 메시지 업데이트
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage':
            messageData.type == 'image' ? "[Image]" : messageData.text,
        'lastMessageId': messageData.messageId,
      });

      return const Result.success(null);
    } catch (e) {
      logger.info('Firestore send message error => $e');
      return Result.error(e.toString());
    }
  }

  Future<Result<String>> uploadImage(String chatId, File file) async {
    try {
      final ref = _storage.ref().child(
          "chat_images/$chatId/${DateTime.now().millisecondsSinceEpoch}.jpg");
      final uploadTask = ref.putFile(file);
      final completedTask = await uploadTask;
      final imgURL = await completedTask.ref.getDownloadURL();
      return Result.success(imgURL);
    } catch (e) {
      logger.info("Error uploading image: $e");
      return Result.error(e.toString());
    }
  }
}
